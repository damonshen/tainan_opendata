request = require \request

url = \http://odata.tn.edu.tw/schoolapi/api/getdata

show = (url, callback)->
  console.log "server get url: #{url}"
  request {
    url: url,
    json: true
  },
  (error, response, body) ->
    if !error and response.statusCode is 200
      callback? body
    else callback? \error
exports.show = show
