request = require \request

url = \http://odata.tn.edu.tw/schoolapi/api/getdata

show = (url, type, callback)->
  console.log "server get url: #{url}"
  request {
    url: url
    encoding: null
  },
  (error, response, body) ->
    if !error and response.statusCode is 200
      switch type
      case \json
        callback? body
      case \csv
        Converter = require \csvtojson .core.Converter
        csvConverter = new Converter constructResult: true
        err, jsonObj <- csvConverter.fromString body
        if err
          err
        callback? jsonObj
    else callback? \error
exports.show = show
