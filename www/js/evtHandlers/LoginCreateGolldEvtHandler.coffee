class LoginCreateGolldEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in login create golld evthandler"

    if name is "login"
      trace data
      if data is "User not found" or data is "Password incorrect"
        alert data
      else
        AppProps.uid = data
        AppProps.store "uid", data
        UI.views.init "AccountGolldView"
        
    if name is "create"
      trace "create"
      if data.indexOf "ERROR - " isnt -1
        alert data.susbtring(8)
      else
        alert "Account created"
        AppProps.uid = data
    
    if name is 'error'
      trace "error : " + data
      trace data