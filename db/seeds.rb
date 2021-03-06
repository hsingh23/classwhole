# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'xmlsimple'

# TODO: FIX THIS FOR SPRING SEMESTER!!  
@semester_start_date = Time.parse("22-Aug-11")
@semester_end_date   = Time.parse("07-Dec-11")

def main
  ParseSemester( '2012', 'spring' )
end

def ParseSemester(year, season)
  clear_database
  # Build the URLs
  # ex: semester = "2011/spring"
  semester = year + "/" + season
  @base_url = "http://courses.illinois.edu/cis/" + semester 
  url = @base_url + "/schedule/index.xml"

  # Grab the response from the URL as a string
  xml_data = Net::HTTP.get_response(URI.parse(url)).body
  # Turn the string into a hash of data 
  catalog = XmlSimple.xml_in(xml_data, 'ForceArray' => ['subject'], 'SuppressEmpty' => nil)
  current_semester = Semester.create(:year => year, :season => season)

  add_subjects_to_semester(current_semester, catalog)

  url_first8week = @base_url + "/schedule/first8weeks/index.xml"
  url_second8week = @base_url + "/schedule/second8weeks/index.xml"
  xml_data_first8week = Net::HTTP.get_response(URI.parse(url_first8week)).body
  xml_data_second8week = Net::HTTP.get_response(URI.parse(url_second8week)).body
  catalog_first8week = XmlSimple.xml_in(xml_data_first8week, 'ForceArray' => ['subject'], 'SuppressEmpty' => nil)
  catalog_second8week = XmlSimple.xml_in(xml_data_second8week, 'ForceArray' => ['subject'], 'SuppressEmpty' => nil)
  semester_slot("first8weeks/", 1, catalog_first8week)
  semester_slot("second8weeks/", 2, catalog_second8week)

  puts "-------\nsemester slots\n-------\n"
  puts "#{Section.all.size} sections"
  Section.transaction do
    Section.all.each do |section|
      section.semester_slot = 3 if section.semester_slot == 0
      section.save
    end
  end
end

def semester_slot(weeks, val, data)
  puts "-------\n#{weeks}\n-------\n"
  subject_catalog = data['subject']
  subject_catalog.each do |subject|
    puts "#{subject['subjectCode']}"
    # Build a url based off of the current subject code
    subject_url = @base_url + "/schedule/" + weeks + subject['subjectCode'] + "/index.xml"
    # Fetch the courses for the subject and decrypt the data from the url
    subject_xml_data = Net::HTTP.get_response(URI.parse(subject_url)).body
    subject_courses = XmlSimple.xml_in(subject_xml_data, 'ForceArray' => ['course','section'], 'SuppressEmpty' => nil)['subject']['course']
    subject_courses.each do |course|
      course['section'].each do |section|
        puts "#{section['referenceNumber']}"
        Section.transaction do
          section = Section.find_by_reference_number(section['referenceNumber'].to_i)
          section.semester_slot = val
          section.save
        end
      end
    end
  end
end

# Parses data to populate all the subject and course data for the semester
# calls: add_sections_to_course
#
def add_subjects_to_semester(current_semester,data)
  subject_catalog = data['subject']
  Subject.transaction do
    subject_catalog.each do |subject|
      puts "-------\n#{subject['subjectCode']}\n-------\n"
      # Add the subject/major to the database
      current_subject = current_semester.subjects.create(
          :phone => subject['phone'],
          :web_site_address => subject['webSiteAddress'],
          :address2 => subject['address2'],
          :contact => subject['contact'],
          :contact_title => subject['contactTitle'],
          :title => subject['subjectDescription'],
          :code => subject['subjectCode'],
          :unit_name => subject['unitName']
      )

      # Build a url based off of the current subject code
      subject_url = @base_url + "/schedule/" + subject['subjectCode'] + "/index.xml"
      # Fetch the courses for the subject and decrypt the data from the url
      subject_xml_data = Net::HTTP.get_response(URI.parse(subject_url)).body

      add_course_to_subject(current_subject, subject_xml_data)
    end
  end
end

# Parses data to create a subject object including courses and sections
# calls: add_sections_to_course
#
def add_course_to_subject(subject, data)
  subject_courses = XmlSimple.xml_in(data, 'ForceArray' => ['course','section'], 'SuppressEmpty' => nil)['subject']['course']

  Course.transaction do
    subject_courses.each do |course|
      current_course = subject.courses.create(
          :number => course['courseNumber'].to_i,
          :hours => course['hours'].to_i,
          :description => course['description'],
          :title => course['title'],
          :subject_code => course['subjectCode'],
          :subject_id => course['subjectId'].to_i
          )
      puts current_course.title
      add_sections_to_course( current_course, course['section'] )
    end
  end
end

def add_sections_to_course(course, data)
  course_sections = data
  Section.transaction do
    course_sections.each do |section|
      section_start_time, section_end_time = parse_hours(section['startTime'], section['endTime'])
      current_section = course.sections.create(
        :room => section['roomNumber'].to_i,
        :days => section['days'],
        :reference_number => section['referenceNumber'].to_i,
        :notes => section['sectionNotes'],
        :section_type => section['sectionType'],
        :instructor => section['instructor'],
        # Time value can be "ARRANGED", not an actual time, so this is stored as nil
        :start_time => section_start_time,
        :end_time => section_end_time,
        :building => section['building'],
        :code => section['sectionId'],
        :course_subject_code => course.subject_code,
        :course_title => course.title,
        :course_number => course.number
        )
    end
  end
end

#
# Description: takes a  string in the format "01:40 PM" and parses it 
#              for a a Time object
# Time.utc(year, month, day, hour, min) → time
#
def parse_hours( start_time_string, end_time_string)
  start_time_match = /(?<hour>\d\d):(?<min>\d\d)\s*(?<am_pm>\w+)/.match(start_time_string)
  return nil if not start_time_match

  end_time_match = /(?<hour>\d\d):(?<min>\d\d)\s*(?<am_pm>\w+)/.match(end_time_string)
  return nil if not end_time_match

  start_hour = start_time_match[:hour].to_i
  end_hour = end_time_match[:hour].to_i

  if( start_time_match[:am_pm] == "PM" and start_time_match[:hour].to_i != 12)
    start_hour += 12 
  end
  if( end_time_match[:am_pm] == "PM" and end_time_match[:hour].to_i != 12)
    end_hour += 12 
  end

  # this year month and day do not matter, as long as it is consistent    
  # TODO: Don't hardcode year you moron
  start_time = Time.utc(1990, 7, 1, start_hour, start_time_match[:min].to_i)
    end_time = Time.utc(1990, 7, 1, end_hour,   end_time_match[:min].to_i)
  return start_time, end_time
end

def clear_database
  # Initialize
  Semester.delete_all
  Subject.delete_all
  Course.delete_all
  Section.delete_all
end

main
