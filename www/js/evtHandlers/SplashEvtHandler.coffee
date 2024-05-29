class SplashEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>
    
    trace "in splash evthandler"
    
    if name is 'error'
      trace "error : " + data
      trace data