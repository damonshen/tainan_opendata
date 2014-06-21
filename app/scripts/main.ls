#initialize the map
mapOption =
  * center: '台南市政府'
    zoom: 13


#go button used to trigger distance measured and select the nearest store
``
var loop_stop = 0;
var stop = 0;
$(document).ready(function(){$('#go').click(function(){
	$('#map').tinyMap(mapOption);
/*	getData();*/
/*	console.log(markerList);*/
	getResultStore();
})});

$(document).ready(function(){$('#clear').click(function(){
	$(document).ready(function(){$('#map').tinyMap('clear','direction')});
	});
	$('#radio-mini-a2').click(function(){
		$('#map').css('display','none');
	});
	$('#radio-mini-a1').click(function(){
		$('#map').tinyMap(mapOption);
		$('#map').css('display','block');
	});
	$('#radio-mini-b2').click(function(){
		$('#food').css('display','none');
		$('#List_Food').css('display','block');
	});
	$('#radio-mini-b1').click(function(){
		$('#food').tinyMap(mapOption);
		$('#List_Food').css('display','none');
		$('#food').css('display','block');
	});
});

``
``
var result = [];
var num = 0;
var n = 0;
var distArray = [];
var getResultStore = function(){
	var List = [];
	var obj;
	getData(function(){
		var i = 0 ;
		var temp;
		loop(i,markerList,loop);

	});
}
``
``
/*control the for loop index to get distance result*/
var route = [];
var loop = function(i,markerList,callback){
	if(n<5){
		i++;
		calcRoute(4,"driving",i,markerList,markerList.length,callback);
	}
	else{
		storeSelect(route);
	}
}
``
``
//calculate the distance between the start and store//
var directionsService = new google.maps.DirectionsService();
var dist;
var test = 0;
function calcRoute(limit,value,i,markerList,markerLength,callback){
		var start = "台南市安平區永華三街270號";
		var end = markerList[i].addr;
		var mode;
		var distance;
		if(value=='driving')
			mode = google.maps.TravelMode.DRIVING;
		else if(value =='walking')
			mode = google.maps.TravelMode.WALKING;
		else
			mode = google.maps.TravelMode.BICYCLING;
		var request = {
			origin:start,
			destination:end,
			travelMode:mode
		};
		var result;

		directionsService.route(request,function(result,status){
			if(status == google.maps.DirectionsStatus.OK){
				distance = result.routes[0].legs[0].distance.value;
				var obj = {
					from:start,
					to:end,
					travel:value
				}
				if(limit*1000>distance){
					console.log("n = "+n+" ,end:"+end+"distance:"+distance);
					route.push(obj);
					n++;
					callback(i,markerList,callback);
				}
			}
			else if(status == google.maps.DirectionsStatus.ZERO_RESULTS){
				console.log("zero result");
			}
			else if(status == google.maps.DirectionsStatus.OVER_QUERY_LIMIT){
				console.log("over query limit");
			}
			else if(status == google.maps.DirectionsStatus.REQUEST_DENIED){
				console.log("request deny");
			}
			else if(status == google.maps.DirectionsStatus.INVALID_REQUEST){
				console.log("invalid request");
			}
			else{
				console.log("unknown error");
			}
		}
		);
}

//show result route on tinymap//
var callbackCount = 0;
var storeSelect= function(route){
	console.log(route);
	var markerObj;
	var marker = [];
	for(var i = 0 ;i < route.length;i++){
		markerObj = {
			addr:route[i].to,
			text:'fuck',
			label:'ffff'
		};
		marker.push(markerObj);
	}
	console.log(marker);
	$(document).ready(function(){$('#map').tinyMap('modify',{direction:route,marker:marker})});
}
``

``
var data;
var storeUrl = 'http://data.tainan.gov.tw/dataset/34e6decf-dd31-4208-a46c-4173279af5fc/resource/7343d994-0378-4714-a72c-89c9ea375794/download/dining.csv'
markerList = [];
var getData = function(callback){
	$.get('/getData',{
		url:storeUrl,
		type:'csv'
	},function(data){
		var i$,latLng,markerObj,obj;
		for(i$ = 0 ; i$ < data.length;i$++){
			obj = data[i$];
			addr = obj.店家地址;
			console.log(obj.店家電話);
			markerObj = {
				addr : addr,
				text : obj.餐飲店家名稱,
		};
			markerList.push(markerObj);
		}
		if(callback && typeof(callback)==="function"){
			callback();		}
	});
}


``
#show the direction to all the result of result , but not used yet
``
var showRoute = function(resultList,start){
	var resultStore = [];

	var storeObj = {
		from:start,
		to:resultList.addr,
		travel:value
	};
	resultStore.push(storeObj);
	$('map').tinyMap({direction:resultStore});
}
``

#select data from server and transform to JSON array
selectData = (type, category, callback)->
  switch type
  #if the request is for restaurant
  case 'restaurant'
    storeUrl = 'http://data.tainan.gov.tw/dataset/34e6decf-dd31-4208-a46c-4173279af5fc/resource/7343d994-0378-4714-a72c-89c9ea375794/download/dining.csv'
    $ .get \/getData {url: storeUrl, type: 'csv'} (data)->
      resultList = []
      #get the basic information of each data and push into an array
      for obj in data
        objCate = parseInt obj.店家分類代碼
        #if the category of the obj is in the category user selected
        if ($.inArray objCate, category) > -1
          latLng =
            * obj.Y坐標
            * obj.X坐標
          dataObj =
            * addr: obj.店家地址
              text: obj.餐飲店家名稱
              phone: obj.店家電話
              detail: obj.店家簡述
              time: obj.營業時間
          #push the info data into array
          resultList.push(dataObj)
        else continue
      callback? resultList
  #if the request is for sport 
  case 'sport'
    sportUrl = 'http://odata.tn.edu.tw/tnsport.json'
    $ .get \/getData {url: sportUrl, type: 'json'} (data)->
        #remove the \r\n and space in the json file
        jsonStr = data.replace /(?:\\[rn])+/g, "" .replace  /\s+/g, ""
        try
          sportResult = $.parseJSON jsonStr
        catch e
          console.log "error: #e"
        dataList = sportResult.pma_xml_export.database.table
        resultList = []
        #get all object in recieved data
        for obj in dataList
          jsonObj = []
          lng = null
          lat = null
          title = null
          #get the basic attributes of this object
          for objAttr in obj.column
            if objAttr.['-name'] is 'title'
              title = objAttr['#text']
            else if objAttr.['-name'] is 'lon'
              lng = objAttr.['#text']
            else if objAttr.['-name'] is 'lat'
              lat = objAttr.['#text']
          jsonObj =
            * addr: [lat, lng]
              text: title
          resultList.push jsonObj
        callback? resultList

#set the document ready
$ ->
  $ \#test .bind 'click', ->
    $ .get \/getData, (data)->
      console.log data

  #activity when navigation to food_choice
  $ document .on 'pagebeforehide', '#food_choice', (e, ui)->
    foodVal = []
    $ '#food_choice :checked' .each ->
      val = $ this .val!
      foodVal .push parseInt val
    console.log foodVal
    selectData 'restaurant', foodVal, PrintFooddata
  $ document .on 'pagebeforecreate', '#sports_map', (e, ui)->
    setTimeout ->
      console.log 'wait'
    , 3000



``
$(function() {
   $("input[type='radio']").checkboxradio();
   $("#radioButton").click();
   $('#sports_submit').click(GetSportList);
   		
   
 });
function GetSportList(){
	var allVals = [];
     $('#sports_choice :checked').each(function() {
      allVals.push($(this).val());
     });
	alert(allVals);
   $.get('\getData', function(data){
   	PrintSportsdata(data);
   	});
}
function PrintFooddata(data){
	//console.log(JSON.stringify(data));
	//console.log(data[0].addr);
	document.getElementById("List_Food").innerHTML = "";
	var content = "";
	for(i=0;i<data.length;i++)
	{
		//document.getElementById("List_Food").innerHTML+= data[i].addr +" - "+ data[i].text+"<br>";
		
		content += "<div data-role='collapsible'><h3>"+data[i].text+"</h3><p>"+data[i].addr+"<br>"+data[i].phone+"<br>"+data[i].time+"<br>"+data[i].detail+"</p></div>";
	}
	$(content).appendTo("#List_Food");
	$('div[data-role=collapsible]').collapsible({
		expand: function(){
			if($(this).context.childElementCount == 2)
			{
				$("<div id = 'map_in_list' style = 'height:300px'></div>").appendTo(this);
				$('#map_in_list').tinyMap(mapOption);
			}
		},
		collapse: function(){
			if($(this).context.childElementCount == 3)
				$(this).context.childNodes[2].remove();
		}
	});
	
}
function PrintSportsdata(data){
	document.getElementById("List_Sports").innerHTML = "";
	var content = "";
	for(i=0;i<data.length;i++)
	{
		//document.getElementById("List_Sports").innerHTML+= data[i].addr +" - "+ data[i].text+"<br>";
		
		content += "<div data-role='collapsible'><h3>"+data[i].title+"</h3><p>"+data[i].addr+"</p></div>";
	}
	$(content).appendTo("#List_Sports");
	$('div[data-role=collapsible]').collapsible();
}
 ``
