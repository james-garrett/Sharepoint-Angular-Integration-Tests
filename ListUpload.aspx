<!DOCTYPE html>  
<html>  
    <head>
            <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.15/angular.min.js"></script>  
            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
            <link rel="stylesheet" type="text/css" href="css/mainStyle.css" />
    </head>
<body>  
    <div ng-app="mainApp" ng-controller="listHandlerController" ng-init="">  
        <br>  
            <div id="contract">
                <ul style="list-style: none;">
                    <div ng-repeat="item in list track by item.ID">
                    <li ng-if="!itemIsSubsection(item.SubSectionNo)"><h1>{{item.SectionNo}}{{item.SubSectionNo}}    <b>{{item.Title}}</b></h1></li>
                        <li ng-if="itemIsSubsection(item.SubSectionNo)"><h2> 
                            {{item.SectionNo}}{{item.SubSectionNo}}    {{item.Title}}
                        </h2>
                        <p>{{item.SectionText}}</p>
                    </ul>
                </div> 
            </div>
    </div>  
  
    <script>
        var mainApp = angular.module("mainApp", []);  
           
        mainApp.controller("listHandlerController", function($scope, $q) {  
            var user = { firstName: "", lastName: ""};  
            // $scope.list = ["1", "2"];
            $scope.list = [];
            
            // console.log("hello world");

            $scope.returnData = function() {
                var x = $scope.list;
                return $scope.list;
            }

            var processResults = function(data) {
                var processedList = [];
                console.log(data.length);
                for(let i = 0; i < data.length; i++) {
                    var itemData = {};
                    // console.log(i);
                    // console.log(data[i]["ID"]);
                    itemData["ID"] = data[i]["ID"];
                    itemData["Title"] = data[i]["Title"];
                    itemData["SectionNo"] = data[i]["Section_x0020_No"];
                    itemData["SectionText"] = data[i]["Section_x0020_Text"];
                    itemData["SubSectionNo"] = data[i]["Subsection_x0020_Number"];
                    itemData["Created"] = data[i]["Created"];
                    // console.log(itemData);
                    processedList.push(itemData);
                }
                    // console.log(processedList); 
                return processedList;
            }

            $scope.itemIsSubsection = function(item) {
                console.log(item);
                console.log("item");
                return (item.indexOf('.0') !== -1)? false : true;
            }

            var win = function(data) {
                // console.log("win");
                console.log(data);
                $scope.$apply(function() {
                    $scope.list = processResults(data);
                });
                console.log($scope.list);
                return $scope.list;
            }

            var help = function() {
                console.log("help");
            }
            
            // $scope.list = $scope.getData();
            // console.log($scope.list);

            // });
            // readList(help, win);
        
            var readList = function(complete, failure) {
                var value1 = {};
                // var deferred = $q.defer();
                // var rootURL = "https://jamesg.sharepoint.com/sites/test1/Lists";
                var rootURL = "https://jamesg.sharepoint.com/sites/test1/";
                // var endpoint = "/_api/web/lists/GetByTitle('" + listname + "')/items?$filter= '" + fieldname + "' eq '" + fieldvalue;
                // var endpoint = "/_api/web/lists/'" + listname + "'/AllItems";
                var endpoint = "_api/web/lists/GetByTitle('Contract1')/items";
                
                $.ajax({
                    url: rootURL + endpoint,
                    // url: "https://jamesg.sharepoint.com/sites/test1/Lists/Contract1/DispForm.aspx?ID=1&e=jEQKdt",
                    async: true,
                    method: "GET",
                    headers: { "Accept": "application/json; odata=verbose" }, //Get verbose JSON format
                    success: function(data) {
                        if(Object.values(data)[0].results.length > 0) {
                            value1 = Object.values(data)[0].results;
                            complete(value1);
                        }
                    },
                    error: function(data) {
                        console.log(data);
                        // failure(data);
                    }
                });
                return (value1.length > 1)? value1.toString() : value1;
            }

            $scope.getData = function($scope) {

                readList(win, help);
            }
            $scope.getData();
    });
    </script>  
</body>  
</html> 