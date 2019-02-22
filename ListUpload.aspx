<!DOCTYPE html>  
<html>  
    <head>
            <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.15/angular.min.js"></script>  
            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    </head>
<body>  
    <div ng-app="mainApp" ng-controller="listHandlerController" data-ng-init="">  
        <!--ng-model binds the input field to the controller property firstName-->  
        First Name: <input type="text" ng-model="user.firstName"><br>  
        <!--ng-model binds the input field to the controller property lastName-->  
        Last Name: <input type="text" ng-model="user.lastName"><br>  
        <br>  
        <!--{{}} AngularJS expression-->  
        Welcome {{fullName()}}  

        <div ng-repeat="item in list">hi {{item}} </div>
    </div>  
  
    <script>
        var mainApp = angular.module("mainApp", []);  
           
        mainApp.controller("listHandlerController", function($scope) {  
            user = { firstName: "", lastName: "", };  
            list = {};
                    
        function fullName($scope) {  
                var x = $scope.user;  
                return x.firstName + " " + x.lastName;  
        }  
        // function controller($scope) {  
            // $scope.user is the property for controller object  
            // firstName & lastName are the properties for user object  
        // }
        // readList().then(function(data) {
        //         list = data;  
        //         console.log(list);
        // });
        // var myDataPromise = myService.readList();

        var win = function(data) {
            console.log("win");
            console.log(data);
            $scope.list = data;
        }

        var help = function() {
            console.log("help");
        }
        readList(help, win);

            // console.log(success);
        // });
    });

    // mainApp.factory('myService', function() {
        // var readList = function($scope, listname, fieldname, fieldvalue, complete, failure) {
        var readList = function($scope, complete, failure) {
            var value1 = {};
            // var deferred = $q.defer();
            // var rootURL = "https://jamesg.sharepoint.com/sites/test1/Lists";
            var rootURL = "https://jamesg.sharepoint.com/sites/test1/";
            // var endpoint = "/_api/web/lists/GetByTitle('" + listname + "')/items?$filter= '" + fieldname + "' eq '" + fieldvalue;
            // var endpoint = "/_api/web/lists/'" + listname + "'/AllItems";
            var endpoint = "_api/web/lists/GetByTitle('Contract1')/items";
            // https://jamesg.sharepoint.com/sites/test1/Lists/Contract1/DispForm.aspx?ID=1&e=jEQKdt
            // https://jamesg.sharepoint.com/sites/test1/Lists/Contract1/DispForm.aspx?ID=2&e=JIfQhU
            console.log(rootURL + endpoint);
            $.ajax({
                url: rootURL + endpoint,
                // url: "https://jamesg.sharepoint.com/sites/test1/Lists/Contract1/DispForm.aspx?ID=1&e=jEQKdt",
                async: true,
                method: "GET",
                headers: { "Accept": "application/json; odata=verbose" }, //Get verbose JSON format
                success: function (data) {
                    // console.log(Object.values(data)[0].results);
                    if(Object.values(data)[0].results.length > 0) {
                        console.log("success!");
                        value1 = Object.values(data)[0].results;
                        console.log(value1);
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

    </script>  
</body>  
</html> 