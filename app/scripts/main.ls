sayHello = ->
  console.log \hello \livescript
sayHello!

$ ('.btn') .click ->
  console.log $('input[name=url]').val()
  inputUrl = $('input[name=url]').val()
  $ .get '/getData' {url: inputUrl} (data)->
    console.log JSON.stringify data
/*
url = \http://odata.tn.edu.tw/ebookapi/api/getOdataSIS?SchoolCode=213628&std_grade=5
data <- $ .get url
console .log data
*/
