class MyAccountGolldEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in account golld evthandler"

    if name is "getaccount"
      trace data
      #data = JSON.parse(data)
      AppProps.store "accdata", data
      data = JSON.parse(data)

      $('#namefield').text data.firstName + " " + data.lastName
      $('#emailfield').text data.email
      $('#unamefield').text data.username
      $('#phonefield').text data.phone

      @view.checkapproved(data)
      @view.checkuploaded(data)
      @view.checkcomplete(data)



    if name is 'error'
      trace "error : " + data
      trace data
