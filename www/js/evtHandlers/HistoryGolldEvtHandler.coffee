class HistoryGolldEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in IN HISTORY EVT HANDLER evthandler"




    if name is 'error'
      trace "error : " + data
      trace data
