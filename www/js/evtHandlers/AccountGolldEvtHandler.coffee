class AccountGolldEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in account golld evthandler"
    if name is "getaccount"
      trace data
      AppProps.store "accdata", data
      data = JSON.parse(data)
      trace data

    if name is "getorders"
      trace data
      AppProps.store "getorders",data
      data = JSON.parse(data)
      trace data

    if name is "getfundorders"


      AppProps.store "getfundorders",data
    #      trace ' HERE HERE HERE '
    #      trace getfundorders
    #data = JSON.parse(data)

    if name is 'error'
      trace "error : " + data
      trace data