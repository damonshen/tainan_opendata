request = require \request

url = \http://odata.tn.edu.tw/schoolapi/api/getdata

request {
  url: url,
  json: true
},
(error, response, body) ->
  if !error and response.statusCode is 200
    console .log body

