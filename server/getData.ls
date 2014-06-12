request = require \request

url = \http://odata.tn.edu.tw/schoolapi/api/getdata

show = (url, type, callback)->
  console.log "server get url: #{url}"
  request {
    url: url,
    json: true
  },
  (error, response, body) ->
    if !error and response.statusCode is 200
      result = switch type
      case \json
        body
      case \csv
        console.log body
        Converter = require \csvtojson .core.Converter
        csvConverter = new Converter constructResult: true
        console.log csvConverter.fromString body, (err, jsonObj) ->
          console.log jsonObj
      callback? result
    else callback? \error
exports.show = show
