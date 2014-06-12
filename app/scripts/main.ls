sayHello = ->
  console.log \hello \livescript
sayHello!

#initialize semantic dropdown
$ \.ui.button .dropdown onChange: (value, text) ->
  inputUrl = $ 'input[name=url]' .val()
  type = value
  $ .get \/getData {url: inputUrl, type: type} (data)->
    result = switch type
    case \json
      JSON.stringify data
    case \csv
      JSON.stringify data
    case \xml
      \xml
    $ \.result .text result

