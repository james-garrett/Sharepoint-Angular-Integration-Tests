<!DOCTYPE html>  
<html>  
    <head>
            <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.15/angular.min.js"></script>  
            <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
            <!-- <script src="controllers/contractRendererController.js"></script> -->
            <link rel="stylesheet" type="text/css" href="css/contractStyle.css" />
            
            <!-- <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script> -->
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

    </head>
<body>  
    <div ng-app="mainApp" ng-controller="contractRendererController" ng-init="" class="container">  
        <br>  
            <div id="contract" class="row">
                <!-- <div class="col-sm-2"></div> -->
                <ul style="list-style: none;">
                    <div ng-repeat="item in list track by item.ID" class="col-sm-8" id="contractBody">
                    <li ng-if="!itemIsSubsection(item.SubSectionNo)"><h1>{{item.SectionNo}}{{item.SubSectionNo}}    <b>{{item.Title}}</b></h1>
                        <p>{{item.SectionText}}</p></li>
                        <li ng-if="itemIsSubsection(item.SubSectionNo)"><h2> 
                            {{item.SectionNo}}{{item.SubSectionNo}}    {{item.Title}}
                        </h2>
                        
                            <!-- <p ng-if="{{images[$index]}}">{{images[$index].link}}</p> -->
                            <img ng-if="getAssociatedImages($index)" id="sectionImg" ng-src="{{getAssociatedImages($index)}}"></img>
                            <p>{{item.SectionText}}</p>
                        </div>
                        <!-- <div class="col-sm-2"></div> -->
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

        var sortListResults = function(list) {
            list.sort(dynamicSortMultiple(["SectionNo", "SubSectionNo"]));
            // list.sort(dynamicSort("SectionNo", 1));
            console.log(list);
            return list;
        }
        
        var dynamicSort = function(property, sortOrder) { 
            /*Default sortOrder is 1 */
            return function(a, b) {
                // console.log(a[property], b[property]);
                var result = (a[property] < b[property]) ? -1: (a[property] > b[property]) ? 1 : 0;
                return result * sortOrder;
            }
        }

        // return function(c, d) {
        //                 console.log(c);
        //                 console.log(c[args[i]], d[args[i]]);
        //                 if(c[args[i]] == d[args[i]] && i < numberOfProperties) {
        //                  console.log("Matching vals");
        //                     i++;
        //                 }
        //                 var result = (c[args[i]] < d[args[i]]) ? -1: (c[args[i]] > d[args[i]]) ? 1 : 0;
        //                 return result * sortOrder;
        //             }

        var dynamicSortMultiple = function(properties) { 
            /*Default sortOrder is 1 */
            var args = properties;
            return function(a, b) {
                var i = 0, result =0, numberOfProperties = args.length;
                // console.log(numberOfProperties);
                while(result === 0 && i < numberOfProperties) {
                    // console.log(a[args[i]]);
                    result = dynamicSort(args[i], 1)(a, b);
                    i++;
                }
                return result;
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
                $scope.list = sortListResults(processListResults(data));
                console.log($scope.list);
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

<style>
    #sectionImg {
    width: 100%;
    height: 100%;
    }

    #contractBody {
        background-color: #ddbea0;
        max-width: 100%;
    }
</style>
</html> 