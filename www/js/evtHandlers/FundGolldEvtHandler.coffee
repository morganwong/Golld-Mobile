class FundGolldEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in account golld evthandler"




    if name is 'error'
      trace "error : " + data
      trace data
