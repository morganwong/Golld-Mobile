class AccountDetailsGolldEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in account details golld evthandler"



    if name is "edit"
      if data is "OK"
        alert "Saved"

      else
        alert data


    if name is 'error'
      trace "error : " + data
      trace data
