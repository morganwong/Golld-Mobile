class BuyLessWaitingEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in buy less waiting evt handler"

    if name is "poll"
      trace data
      if data is "waiting"
        trace "waiting..."
        setTimeout @view.poll, 2000
      else if data is "complete"
        trace "COMPLETE"
        UI.views.init "BuyLessCompleteGolldView"
      else if data is "failed"
        trace "FAILED"
        UI.views.init "BuyLessFailedGolldView"
      else
        trace "ERROR"

    if name is 'error'
      trace "error : " + data
      trace data