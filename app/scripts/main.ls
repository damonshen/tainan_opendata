sayHello = ->
  console.log \hello \livescript
sayHello!

$ \.send-btn .click ->
  console.log $('input[name=url]').val()
  inputUrl = $ 'input[name=url]' .val()
  type = $ this .attr \name
  $ .get \/getData {url: inputUrl, type: type} (data)->
    result = switch type
    case \json
      JSON.stringify data
    case \xml
      \xml
    case \csv
      JSON.stringify data
    $ \.result .text result

/*
url = \http://odata.tn.edu.tw/ebookapi/api/getOdataSIS?SchoolCode=213628&std_grade=5
data <- $ .get url
console .log data
*/
