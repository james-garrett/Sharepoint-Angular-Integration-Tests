<!DOCTYPE html>  
<html>  
<body>  
    <div ng-app="" ng-controller="controller">  
        <!--ng-model binds the input field to the controller property firstName-->  
        First Name: <input type="text" ng-model="user.firstName"><br>  
        <!--ng-model binds the input field to the controller property lastName-->  
        Last Name: <input type="text" ng-model="user.lastName"><br>  
        <br>  
        <!--{{}} AngularJS expression-->  
        Welcome {{fullName()}}  
    </div>  
  
    <script>  
        function controller($scope) {  
            // $scope.user is the property for controller object  
            // firstName & lastName are the properties for user object  
            $scope.user = { firstName: "", lastName: "", };  
            $scope.fullName = function () {  
                var x = $scope.user;  
                return x.firstName + " " + x.lastName;  
            }  
        }  
    </script>  
    <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.15/angular.min.js"></script>  
</body>  
</html> 