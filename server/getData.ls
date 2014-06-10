request = require \request

url = \http://odata.tn.edu.tw/schoolapi/api/getdata

show = (callback)->
  request {
    url: url,
    json: true
  },
  (error, response, body) ->
    if !error and response.statusCode is 200
      callback? body
    else return \error
exports.show = show
