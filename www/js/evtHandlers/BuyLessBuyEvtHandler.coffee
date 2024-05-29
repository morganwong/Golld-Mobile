class BuyLessBuyEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in buy less buy evt handler"

    if name is "makebuylessorder"
      trace data
      if data is "OK"
        UI.views.init "BuyLessWaitingGolldView"
      else
        alert data

    if name is 'error'
      trace "error : " + data
      trace data