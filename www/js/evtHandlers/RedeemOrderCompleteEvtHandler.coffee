class RedeemOrderCompleteEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in redeem order complete evt handler"

    if name is "getorder"
      trace data
      @view.order = JSON.parse data
      @view.filldetails(@view.order)

    if name is 'error'
      trace "error : " + data
      trace data