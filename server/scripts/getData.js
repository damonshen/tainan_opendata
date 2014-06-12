(function(){
  var request, url, show;
  request = require('request');
  url = 'http://odata.tn.edu.tw/schoolapi/api/getdata';
  show = function(url, type, callback){
    console.log("server get url: " + url);
    return request({
      url: url,
      json: true
    }, function(error, response, body){
      var result, Converter, csvConverter;
      if (!error && response.statusCode === 200) {
        result = (function(){
          switch (type) {
          case 'json':
            return body;
          case 'csv':
            console.log(body);
            Converter = require('csvtojson').core.Converter;
            csvConverter = new Converter({
              constructResult: true
            });
            return console.log(csvConverter.fromString(body, function(err, jsonObj){
              return console.log(jsonObj);
            }));
          }
        }());
        return typeof callback === 'function' ? callback(result) : void 8;
      } else {
        return typeof callback === 'function' ? callback('error') : void 8;
      }
    });
  };
  exports.show = show;
}).call(this);
