class LoginEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in login evthandler"

    if name is "login"
      trace data
      r = data.indexOf "fail - "
      trace "r is " + r
      if r isnt -1
        em = data.substring 7
        alert em.toUpperCase()
      else
        AppProps.store "uid", data
        UI.views.init "AccountGolldView"

    if name is 'error'
      trace "error : " + data
      trace data