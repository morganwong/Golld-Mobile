class KYCGolldEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in kyc golld evthandler"

#    if name is "getaccount"
#      trace data
#      data = JSON.parse(data)
#
#      @view.filesuploaded(data)

    if name is "edit"
      if data is "OK"
        alert "Saved"

      else
        alert data


    if name is 'error'
      trace "error : " + data
      trace data
