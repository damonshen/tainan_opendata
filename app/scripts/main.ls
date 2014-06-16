#initialize the map
mapOption =
  * center: '台南市政府'
    zoom: 13
$ \#map .tinyMap mapOption

#initialize semantic dropdown
$ \.ui.button .dropdown onChange: (value, text) ->
  #get the value of inputs
  inputUrl = $ 'input[name=url]' .val()
  type = value
  #show loading button before sending request to the server
  $ \.ui.button .toggleClass 'loading'
  #call the getData for getting the open data
  $ .get \/getData {url: inputUrl, type: type} (data)->
    $ \.ui.button .toggleClass 'loading'
    result = switch type
    case \json
      JSON.stringify data
    case \csv
      JSON.stringify data
    case \xml
      \xml
    $ \.result .text result

#get the information of restaurant
$ \.init-btn .click ->
  $ \.ui.button .toggleClass 'loading'
  #the url of store in open data
  storeUrl = 'http://data.tainan.gov.tw/dataset/34e6decf-dd31-4208-a46c-4173279af5fc/resource/7343d994-0378-4714-a72c-89c9ea375794/download/dining.csv'
  sportUrl = 'http://odata.tn.edu.tw/tnsport.json'
  #get the data of stores from http request of getData
  $ .get \/getData {url: storeUrl, type: 'csv'} (data)->
    markerList = []
    #get the basic information of each data and push into an array
    for obj in data
      latLng =
        * obj.Y坐標
        * obj.X坐標
      markerObj =
        * addr: latLng
          text: obj.餐飲店家名稱
      #push the info data into array
      markerList.push(markerObj)
    $ \#map .tinyMap 'modify' marker: markerList
  #get the data of stores from http request of getData
  $ .get \/getData {url: sportUrl, type: 'json'} (data)->
    #remove the \r\n and space in the json file
    jsonStr = data.replace /(?:\\[rn])+/g, "" .replace  /\s+/g, ""
    try
      sportResult = $.parseJSON jsonStr
    catch e
      console.log "error: #e"
    dataList = sportResult.pma_xml_export.database.table
    markerList = []
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
          icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png'
      markerList.push jsonObj
    $ \#map .tinyMap 'modify' marker: markerList
    $ \.ui.button .toggleClass 'loading'


