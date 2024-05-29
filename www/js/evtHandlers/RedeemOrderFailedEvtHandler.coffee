class RedeemOrderFailedEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in redeem order failed evt handler"

    if name is "getfailedorder"
      trace data
      @view.order = JSON.parse data
      @view.filldetails(@view.order)

    if name is 'error'
      trace "error : " + data
      trace data