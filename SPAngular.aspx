<html>  
   <head>  
      <title>Angular JS Implemented in SharePoint </title>  
   </head>  
     
   <body>  
      <h2>AngularJS_SharePoint Application</h2>  
        
      <div ng-app = "mainApp" ng-controller = "shapeController">  
        <div ng-repeat="item in items">      
            <p>{{item.Title}}</p>      
        </div>      
           
         
      </div>  
          
      <script src = "https://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>  
        
      <script>  
         var mainApp = angular.module("mainApp", []);  
           
         mainApp.controller("shapeController", function($scope) {  
             GetListItems($scope, "newlist");  //Call your SharePoint Function  
         });           
        function GetListItems($scope, listName){      
                        $.ajax({      
                            url: _spPageContextInfo.webAbsoluteUrl+"/_api/web/lists/GetByTitle('"+listName+"')/items",      
                            method: "GET",      
                            async: false,      
                            headers: { "Accept": "application/json;odata=verbose" },      
                            success: function(data){      
                                $scope.items = data.d.results;      
                            },      
                            error: function(sender,args){      
                                console.log(args.get_message());      
                            }      
                        });      
}   
      </script>  
        
   </body>  
</html>   