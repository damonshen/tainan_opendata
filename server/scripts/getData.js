(function(){
  var request, url, show;
  request = require('request');
  url = 'http://odata.tn.edu.tw/schoolapi/api/getdata';
  show = function(url, callback){
    console.log("server get url: " + url);
    return request({
      url: url,
      json: true
    }, function(error, response, body){
      if (!error && response.statusCode === 200) {
        return typeof callback === 'function' ? callback(body) : void 8;
      } else {
        return typeof callback === 'function' ? callback('error') : void 8;
      }
    });
  };
  exports.show = show;
}).call(this);
