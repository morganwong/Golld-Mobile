class RedeemOrderEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in redeem order evt handler"

    if name is "makeaccountorder"
      trace data
      if data is "OK"
        UI.views.init "RedeemOrderWaitingGolldView"
      else
        alert data

    if name is 'error'
      trace "error : " + data
      trace data