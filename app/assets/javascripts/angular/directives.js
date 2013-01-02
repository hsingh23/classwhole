angular.module('directives', [])
  .directive('autocomplete', function() {
    return {
      link: function (scope, iElement, iAttrs) {
              $(function() {
                var autocomplete = new Autocomplete();
                autocomplete.input_suggestion = ".autocomplete-suggestion";
                autocomplete.input = "#autocomplete-list";
                autocomplete.ajax_search_url = "../courses/search/auto/subject/";
                autocomplete.course_select = add_course_callback;
                autocomplete.init();

                function add_course_callback(event, ui) {
                  event.preventDefault();
                  if ( ui.item ) {
                    var class_id = ui.item.id;
                    autocomplete.clear();
                    scope.$apply(function($scope) {
                      $scope.addCourse(class_id);
                    });
                  }
                }
              });
            }
    }
  })
  .directive("section", function() {
    return {
      link: function($scope, iElement, iAttrs) {
        $(function() {
          Schedule.layoutSection($(iElement), $scope.section, $scope.hourRange[0]); 
        });
      }
    }
  })
  .directive("reverseText", function() {
    return {
      link: function($scope, iElement, iAttrs) {
        var text = $(iElement).text().split("").reverse().join("");
        var a = $("<a/>").attr("href", "mailto:" + text )
                         .text( text );
        $(iElement).empty().append(a);
      }
    }
  })
  ;
