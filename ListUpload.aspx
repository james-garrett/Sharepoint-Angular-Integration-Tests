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
                    <div class="row" ng-repeat="item in list track by item.ID">
                    <li ng-if="!itemIsSubsection(item.SubSectionNo)" class="col-sm-9" id="contractBody">
                        <div class="card bg-light mb-3">
                            <h1 class="card-title">{{item.SectionNo}}{{item.SubSectionNo}}    <b>{{item.Title}}</b></h1>
                            <p>{{item.SectionText}}</p>
                        </div>
                        <!-- <div class="col-sm-4 card bg-light mb-3" id="userReport">
                                <div id="userPanel">
                                        
                                </div> 
                        </div> -->
                    </li>
                    <li ng-if="itemIsSubsection(item.SubSectionNo)" class="col-sm-9" id="contractBody">
                        <div class="card bg-light mb-3">
                            <h2 class="card-title">{{item.SectionNo}}{{item.SubSectionNo}}    {{item.Title}}
                            </h2>
                            <img class="card-img" ng-if="getAssociatedImages($index)" id="sectionImg" ng-src="{{getAssociatedImages($index)}}"></img>
                            <p>{{item.SectionText}}</p>
                    
                        </div>
                    </li>
                    <div class="col-sm-3 card bg-light mb-3" id="userReport" ng-if="getAssociatedUsers($index, 0)">
                        <div ng-repeat="user in getAssociatedUsers($parent.$index, $index)" id="userPanel">
                            <p>{{user.title}}</p>
                        </div> 
                    </div>
                    </div>
                        <form>
                            <div id="addItem" class="form-group">
                                <label for="inputTitle">Title</label>
                                <input type="text" name ="Title" id="inputTitle" ng-model="newItem.Title"/>
                            </div>
                            <div id="addItem" class="form-group">
                                <label for="inputText">Text</label>
                                <input type="text" name ="Text" id="inputText" ng-model="newItem.Text"/>
                            </div>
                            <div id="addItem" class="form-group">
                                <label for="inputSectionNo">Section Number</label>
                                <input type="text" name ="SectionNo" id="inputSectionNo" ng-model="newItem.SectionNo"/>
                            </div>
                            <div id="addItem" class="form-group">
                                <label for="inputSubSectionNo">Subsection Number (If Applicable)</label>
                                <input type="text" name ="SubSectionNo" id="inputSubSectionNo" ng-model="newItem.SubSectionNo"/>
                            </div>
                            <div id="addItem" class="form-group">
                                <div>
                                    <input id="getFile" type="file" (change)="onFileChnaged($event)" ng-model="newItem.Attachments"/>
                                </div>
                                <div>
                                    <button ng-click="writeListItem(newItem.Title, newItem.Text, newItem.SectionNo, newItem.SubSectionNo, newItem.Attachments)">Add Section</button>
                                </div>
                            </div>
                        </form>
                        
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
        $scope.digest = null;
        $scope.users = {};

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
            // console.log(list);
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

        var dynamicSortMultiple = function(properties) { 
            /*Default sortOrder is 1 */
            var args = properties;
            return function(a, b) {
                var i = 0, result =0, numberOfProperties = args.length;
                while(result === 0 && i < numberOfProperties) {
                    result = dynamicSort(args[i], 1)(a, b);
                    i++;
                }
                return result;
            }
        }

        var processListResults = function(data) {
            var processedList = [];
            for(let i = 0; i < data.length; i++) {
                var itemData = {};
                itemData["ID"] = data[i]["ID"];
                itemData["Title"] = data[i]["Title"];
                itemData["SectionNo"] = data[i]["Section_x0020_No"];
                itemData["SectionText"] = data[i]["Section_x0020_Text"];
                itemData["SubSectionNo"] = data[i]["Subsection_x0020_Number"];
                itemData["Created"] = data[i]["Created"];
                if(data[i]["Attachments"] == true) {
                    console.log("image found" + data[i]["AttachmentFiles"]["__deferred"]["uri"]);
                    itemData["Image"] =  data[i]["AttachmentFiles"]["__deferred"]["uri"];
                }
                processedList.push(itemData);
            }
            return processedList;
        }

        var processImageResults = function(data) {
            var processedList = [];
            for(let i = 0; i < data.length; i++) {
                if(data[i]["AttachmentFiles"] && data[i]["AttachmentFiles"]["results"].length > 0) {
                    let processedItem = {};
                    for(let j = 0; j < data[i]["AttachmentFiles"]["results"].length; j++) {
                        console.log(data[i]["AttachmentFiles"]["results"][j]["ServerRelativeUrl"]);
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
            console.log(data);
            $scope.$apply(function() {
                $scope.list = sortListResults(processListResults(data));
            });
            return $scope.list;
        }

        var setImageData = function(data) {
            $scope.$apply(function() {
                var images = processImageResults(data);
                $scope.images = images;
            });
            return $scope.list;
        }

        var help = function() {
            console.log("help");
        }
            
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

        var postSuccess = function() {
            console.log("Yay success");
            $scope.getImages();
            $scope.getData();
        }   

        $scope.writeListItem = function(title, sectionText, sectionNo, subSectionNo, attachments) {
            var item = {};
            var rootURL = "https://jamesg.sharepoint.com/sites/test1/";
            var endpoint = "_api/web/lists/GetByTitle('Contract1')/items";

            console.log( typeof title, typeof sectionNo, typeof sectionText, typeof subSectionNo, attachments);
            
            item["Title"] = title;
            item["Section_x0020_No"] = parseFloat(sectionNo);
            item["Section_x0020_Text"] = sectionText;
            item["Subsection_x0020_Number"] = subSectionNo;
            
            // item["Created"]
            // console.log(data[i].Attachments);
            if(attachments) {
                item["Attachments"] = attachments;
            }
            $scope.addToList(rootURL, endpoint, 'Contract1', item, postSuccess);
        }      

        $scope.addToList = function(rootUrl, endpoint, listName, item, success) {
            item["__metadata"] = { 'type': 'SP.Data.' + listName + 'ListItem'};
            console.log(item);

            // var ajxUrl = rootUrl + endpoint;
            console.log($scope.digest);
            $.ajax({
                url: rootUrl + endpoint,
                async: false,
                type: "POST",
                contentType: "application/json; odata=verbose",
                data: JSON.stringify(item),
                headers: {
                    "Accept": "application/json;odata=verbose",
                    "X-RequestDigest": $scope.digest,
                    // "IF-MATCH": "*",
                    "content-type": "application/json;odata=verbose",
                    "X-HTTP-Method": "POST",
                },
                success: function(data) {
                    success(data);
                },
                error: function(data) {
                    // failure(data);
                    console.log(data);
                    console.log(data.toString());
                }
            });
        }

        function getDigest(cbsuccess) {
            var rootURL = "https://jamesg.sharepoint.com/sites/test1/";
			$.ajax({
				url: rootURL + "_api/contextinfo",
				async: false,
				type: "POST",
				headers: {
					"accept": "application/json;odata=verbose",
					"content-type": "application/json;odata=verbose"
				},
				success: function(res1, res2) {
                    var digest = res1.d.GetContextWebInformation.FormDigestValue;
                    // console.log(typeof digest);
					cbsuccess(digest);
				},
				error: function(res1, res2) {
					// cberror(res1, res2);
				}
			});
        }
        
        $scope.getUsers = function(success) {
            var rootURL = "https://jamesg.sharepoint.com/sites/test1/";


            // var endpoint = "_api/SP.UserProfiles.PeopleManager/GetMyProperties";
            var endpoint = "_api/web/Lists/GetByTitle('Contract1')/Items?$expand=Complying_x0020_Parties&$select=*,Complying_x0020_Parties/Title";
            
            $.ajax({
                url: rootURL + endpoint,
                async: false,
                type: "GET",
                headers: {
                    "accept": "application/json;odata=verbose",
                    "content-type": "application/json;odata=verbose",
                    "X-RequestDigest": $scope.digest,
                }, 
                success: function(data) {
                    var users = Object.values(data)[0].results;
                    // console.log(users);
                    success(users);
                }, 
                error: function(error) {
                    console.log(error);
                }
            })
        }

        $scope.setUsers = function(userList) {
            // console.log(userList);
            var users = [];
            for(let i = 0; i < userList.length; i++) {
                if(userList[i]["Complying_x0020_Parties"]["results"] != undefined) {
                    // console.log(userList[i]["Complying_x0020_Parties"]["results"]);
                    var complyingParties = userList[i]["Complying_x0020_Parties"]["results"];
                    var listOfParties = [];
                    for(let j = 0; j < complyingParties.length; j++) {
                        // console.log(complyingParties[j]);
                        listOfParties.push({"title": complyingParties[j]["Title"], "userID": complyingParties[j]["__metadata"]["id"],
                                         "index": i});
                        
                                        }
                    users.push(listOfParties);
                    // console.log(users);
                }
            }
            $scope.users = users;
        }

        $scope.setDigest = function(data) {
            // console.log(data);s
            $scope.digest = data;
        }

        $scope.getImages = function($scope) {
            // console.log("hi");
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

        $scope.getAssociatedUsers = function(index) {
            console.log($scope.users);
            if($scope.users && $scope.users[index]) {
                return $scope.users[index];
            }
        }

        var uploadFile = function() {
            var serverRelativeUrlToFolder = '/shared documents';
            var fileInput = jQuery('#getFile');
            var newName = jQuery('#getFile').val();

        }

        var getFileBuffer = function() { //converts file to an array buffer
            var deferred = jQuery.Deferred();
            var reader = new FileReader();
            reader.onloadend = function(e) {
                deferred.resolve(e.target.result);
            }
            reader.onerror = function(e) {
                deferred.reject(e.target.error);
            }
            reader.readAsArrayBuffer(fileInput[0].files[0]);
            return deferred.promise();
        }

        var addFileToFolder = function(arrayBuffer, fileInput) {
            var parts = fileInput[0].value.split('\\');
            var fileName = parts[parts.length - 1];

            var appWebUrl = decodeURIComponent(getQueryStringParameter("SPAppWebUrl"));
            var hostWebUrl = decodeURIComponent(getQueryStringParameter("SPHostUrl"));

            var fileCollectionEndpoint = String.format("{0}/_api/sp.appcontextsite(@target)/web/getfolderbyserverrelativeurl('{1}')/files" + 
            "/add(overwrite=true, url='{2}')?@target='{3}'",
            appWebUrl, serverRelativeUrlToFolder, fileName, hostWebUrl);
        }



        getDigest($scope.setDigest);
        console.log($scope.digest);
        $scope.getImages();
        $scope.getData();
        $scope.getUsers($scope.setUsers);
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
        /* background-color: #ddbea0; */
        display: block;
        max-width: 100%;
    }

    #addItem {
        /* background-color: #ddbea0; */
        max-width: 100%;
        padding: 10px;
    }
    #userReport {
        display: block;
    }
    .container {
        max-width: 100%;
    }
</style>
</html> 