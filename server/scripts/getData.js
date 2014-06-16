(function(){
  var request, url, show;
  request = require('request');
  url = 'http://odata.tn.edu.tw/schoolapi/api/getdata';
  show = function(url, type, callback){
    console.log("server get url: " + url);
    return request({
      url: url,
      encoding: null
    }, function(error, response, body){
      var Converter, csvConverter;
      if (!error && response.statusCode === 200) {
        switch (type) {
        case 'json':
          return typeof callback === 'function' ? callback(body) : void 8;
        case 'csv':
          Converter = require('csvtojson').core.Converter;
          csvConverter = new Converter({
            constructResult: true
          });
          return csvConverter.fromString(body, function(err, jsonObj){
            if (err) {
              err;
            }
            return typeof callback === 'function' ? callback(jsonObj) : void 8;
          });
        }
      } else {
        return typeof callback === 'function' ? callback('error') : void 8;
      }
    });
  };
  exports.show = show;
}).call(this);
