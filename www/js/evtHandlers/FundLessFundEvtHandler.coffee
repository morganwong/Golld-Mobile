class FundLessFundEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in fund less fund evt handler"

    if name is "fundaccountstripe"
      trace data
      if data is "OK"
        UI.views.init "AccountGolldView"
        alert('Transaction Complete')
      else
        alert data

    if name is 'error'
      trace "error : " + data
      trace data