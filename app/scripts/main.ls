sayHello = ->
  console.log \hello \livescript
sayHello!

#initialize semantic dropdown
$ \.ui.button .dropdown onChange: (value, text) ->
  #get the value of inputs
  inputUrl = $ 'input[name=url]' .val()
  type = value
  #show loading button before sending request to the server
  $ \.ui.button .toggleClass 'loading'
  #call the getData for getting the open data
  $ .get \/getData {url: inputUrl, type: type} (data)->
    $ \.ui.button .toggleClass 'loading'
    result = switch type
    case \json
      JSON.stringify data
    case \csv
      JSON.stringify data
    case \xml
      \xml
    $ \.result .text result

