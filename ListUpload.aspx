<!DOCTYPE html>  
<html>  
    <head>
            <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.15/angular.min.js"></script>  
            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    </head>
<body>  
    <div ng-app="mainApp" ng-controller="listHandlerController" ng-init="">  
        <!--ng-model binds the input field to the controller property firstName-->  
        First Name: <input type="text" ng-model="user.firstName"><br>  
        <!--ng-model binds the input field to the controller property lastName-->  
        Last Name: <input type="text" ng-model="user.lastName"><br>  
        <br>  
        <!--{{}} AngularJS expression-->  
        <!-- {{ getData() }} -->
        <!-- <div> hi {{list = getData();""}}  -->
            <!-- {{getData()}} -->
            <p ng-repeat="item in list">p{{item}}</p> 
        <!-- </div> -->
        <!-- Welcome {{fullName()}}   -->
        <!-- {{ returnData() }} -->
    </div>  
  
    <script>
        var mainApp = angular.module("mainApp", []);  
           
        mainApp.controller("listHandlerController", function($scope, $q) {  
            var user = { firstName: "", lastName: ""};  
            // $scope.list = ["1", "2"];
            $scope.list = [];
            console.log("hello world");
            
                    
        $scope.fullName = function() {  
            var x = $scope.user;  
            return x.firstName + " " + x.lastName;  
        }  

        $scope.returnData = function() {
            var x = $scope.list;
            return $scope.list;
        }

        var win = function(data) {
            // console.log("win");
            // console.log(data);
            // $scope.list = data;
            return data;
        }

        var help = function() {
            console.log("help");
        }

        $scope.getData = function($scope) {
            // console.log(readList(help, win));
            var d = $q.defer();
            var a = readList(help, win).success(function(data) {
                // console.log(data.d.results);
                var t = processResults(data.d.results);
                // console.log(t);
                return t;
            });
            console.log(a);
        }

        var processResults = function(data) {
            var processedList = [];
            for(let i = 0; i < data.length; i++) {
                // console.log(data[i]["ID"]);
                processedList[i] = data[i]["ID"];
            }
            return processedList;
        }
        // $scope.list = $scope.getData();
        // console.log($scope.list);

        // });
        // readList(help, win);
    
        $scope.readList = function($scope, complete, failure) {
            var value1 = {};
            // var deferred = $q.defer();
            // var rootURL = "https://jamesg.sharepoint.com/sites/test1/Lists";
            var rootURL = "https://jamesg.sharepoint.com/sites/test1/";
            // var endpoint = "/_api/web/lists/GetByTitle('" + listname + "')/items?$filter= '" + fieldname + "' eq '" + fieldvalue;
            // var endpoint = "/_api/web/lists/'" + listname + "'/AllItems";
            var endpoint = "_api/web/lists/GetByTitle('Contract1')/items";
            
            return $.ajax({
                url: rootURL + endpoint,
                // url: "https://jamesg.sharepoint.com/sites/test1/Lists/Contract1/DispForm.aspx?ID=1&e=jEQKdt",
                async: true,
                method: "GET",
                headers: { "Accept": "application/json; odata=verbose" }, //Get verbose JSON format
                success: function (data) {
                    // console.log(Object.values(data)[0].results);
                    if(Object.values(data)[0].results.length > 0) {
                        // console.log("success!");
                        value1 = Object.values(data)[0].results;
                        // console.log(value1);
                        $scope.list = value1;
                        console.log($scope.list);
                        complete(value1);
                        
                        // return deferred.promise;
                        // return value1;
                    }
                },
                error: function(data) {
                    console.log(data);
                    failure(data);
                }
            });
            // if(value1.length > 0) {
            //     for(let i = 0; i < value1.length; i++) {
            //     console.log(value1[i][0]);
            // }
            // }
            return (value1.length > 1)? value1.toString() : value1;
        }
    // });
    });
    </script>  
</body>  
</html> 