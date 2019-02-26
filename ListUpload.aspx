<!DOCTYPE html>  
<html>  
    <head>
            <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.15/angular.min.js"></script>  
            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
            <!-- <script src="controllers/contractRendererController.js"></script> -->
            <link rel="stylesheet" type="text/css" href="css/contractStyle.css" />
    </head>
<body>  
    <div ng-app="mainApp" ng-controller="contractRendererController" ng-init="">  
        <br>  
            <div id="contract">
                <ul style="list-style: none;">
                    <div ng-repeat="item in list track by item.ID">
                    <li ng-if="!itemIsSubsection(item.SubSectionNo)"><h1>{{item.SectionNo}}{{item.SubSectionNo}}    <b>{{item.Title}}</b></h1></li>
                        <li ng-if="itemIsSubsection(item.SubSectionNo)"><h2> 
                            {{item.SectionNo}}{{item.SubSectionNo}}    {{item.Title}}
                        </h2>
                        
                            <!-- <p ng-if="{{images[$index]}}">{{images[$index].link}}</p> -->
                            <img ng-if="getAssociatedImages($index)" id="sectionImg" ng-src="{{getAssociatedImages($index)}}"></img>
                        <!-- </div> -->
                        <p>{{item.SectionText}}</p>
                    </ul>
                </div> 
            </div>
    </div>    
</body>  
<script>
'use strict';

var mainApp = angular.module("mainApp", []);  
mainApp.controller('contractRendererController',
function contractRendererController($scope) {
    // mainApp.controller("listHandlerController", function($scope, $q) {  
        var user = { firstName: "", lastName: ""};  
        // $scope.list = ["1", "2"];
        $scope.list = [];
        $scope.images = [];
        
        // console.log("hello world");

        $scope.returnData = function() {
            var x = $scope.list;
            return $scope.list;
        }

        $scope.getAssociatedImages = function(index) {
            if($scope.images.length > 0) {

                for(let i = 0; i < $scope.images.length; i++) {
                    if($scope.images[i].index == index) {
                        return $scope.images[i].link;
                    }
                }
            } else{ 
                return 0;
            }
        }

        var processListResults = function(data) {
            var processedList = [];
            // console.log(data.length);
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
                // console.log(data[i].Attachments);
                if(data[i]["Attachments"] == true) {
                    console.log("image found" + data[i]["AttachmentFiles"]["__deferred"]["uri"]);
                    itemData["Image"] =  data[i]["AttachmentFiles"]["__deferred"]["uri"];
                }
                // console.log(itemData);
                processedList.push(itemData);
            }
                // console.log(processedList); 
            return processedList;
        }

        var processImageResults = function(data) {
            var processedList = [];
            // console.log(data);
            for(let i = 0; i < data.length; i++) {
                // console.log(data[i]);
                if(data[i]["AttachmentFiles"] && data[i]["AttachmentFiles"]["results"].length > 0) {
                    let processedItem = {};
                    for(let j = 0; j < data[i]["AttachmentFiles"]["results"].length; j++) {
                        console.log(data[i]["AttachmentFiles"]["results"][j]["ServerRelativeUrl"]);
                        // console.log(processedItem.length);
                        processedItem["index"] = i;
                        processedItem["link"] = data[i]["AttachmentFiles"]["results"][j]["ServerRelativeUrl"];    
                    }
                    processedList.push(processedItem);    
                }
            }
            return processedList;
        }

        $scope.itemIsSubsection = function(item) {
            return (item.indexOf('.0') !== -1)? false : true;
        }

        var setTextData = function(data) {
            // console.log("win");
            // console.log(data);
            $scope.$apply(function() {
                $scope.list = processListResults(data);
            });
            // console.log($scope.list);
            return $scope.list;
        }

        var setImageData = function(data) {
            // console.log("win");
            console.log(data);
            $scope.$apply(function() {
                var images = processImageResults(data);
                console.log(images);
                $scope.images = images;
            });
            // console.log($scope.list);
            return $scope.list;
        }

        var help = function() {
            console.log("help");
        }
        
        // $scope.list = $scope.getData();
        // console.log($scope.list);

        // });
        // readList(help, win);
    
        var readList = function(complete, failure, rootURL, endpoint) {
            var value1 = {};
            // var deferred = $q.defer();
            // var rootURL = "https://jamesg.sharepoint.com/sites/test1/Lists";
            // var endpoint = "/_api/web/lists/GetByTitle('" + listname + "')/items?$filter= '" + fieldname + "' eq '" + fieldvalue;
            // var endpoint = "/_api/web/lists/'" + listname + "'/AllItems";
            
            $.ajax({
                url: rootURL + endpoint,
                // url: "https://jamesg.sharepoint.com/sites/test1/Lists/Contract1/DispForm.aspx?ID=1&e=jEQKdt",
                async: true,
                method: "GET",
                headers: { "Accept": "application/json; odata=verbose" }, //Get verbose JSON format
                success: function(data) {
                    // console.log(data);
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

        $scope.getImages = function($scope) {
            console.log("hi");
            var rootURL = "https://jamesg.sharepoint.com/sites/test1/";
            // var endpoint = "_api/lists/GetByTitle('Contract1')/items?$filter=Id%20eq%202451&$select=Attachments,AttachmentFiles&$expand=AttachmentFiles";
            var endpoint = "_api/lists/GetByTitle('Contract1')/items?$select=AttachmentFiles,Title,AttachmentFiles/ServerRelativeUrl&$expand=AttachmentFiles";
            // var endpoint = "_api/web/lists/GetByTitle('Contract1')/RootFolder";
            readList(setImageData, help, rootURL, endpoint); 
        }

        $scope.getData = function($scope) {
            var rootURL = "https://jamesg.sharepoint.com/sites/test1/";
            var endpoint = "_api/web/lists/GetByTitle('Contract1')/items";
            readList(setTextData, help, rootURL, endpoint);
        }
        $scope.getImages();
        $scope.getData();
    });
    // }
// );
</script>
</html> 