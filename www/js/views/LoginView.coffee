class LoginView extends BaseView
  constructor: ()->
    super("LoginView")

    @template = @tmpl
    @evtHandler = new LoginEvtHandler(@)
    @evtHandler.net.bindEvtToLink 'login', NetEvtLinks.rest.AccountController.login

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "AdminView"})

    if AppProps.get("uid")?
      @evtHandler.handleEvt "login", AppProps.get "uid"

    ctx = @
    $('button').click ->
      switch $(this).attr('id')
        when "loginbutton"
          ctx.login()
        when "switchtocreatebutton"
          $('#loginform').hide()
          $('#createform').show()
        when "createaccountbutton"
          ctx.create()
        when "switchtologinbutton"
          $('#createform').hide()
          $('#loginform').show()

  login : () =>
    @evtHandler.net.verbose(true).body({
      u : $('#loginusername').val()
      p : $('#loginpassword').val()
    }).post "login"


  tmpl: (data) ->
    """
      <div class="has-header">

        <div class='padding5'>
          <div class='padding5'><img src='img/CoinGollldLogo150px.png'/></div>
          <div class='content'>

            <div id='loginform'>
              <label class='item item-input'>
                <input id='loginusername' type='text' autocapitalize="none" placeholder='Username / Email'/>
              </label>
              <label class='item item-input'>
                <input id='loginpassword' type='password' placeholder='Password'/>
              </label>
              <button class='button button-full button-dark' id='loginbutton'>Login</button>
              <span style='color: blue' onclick="UI.views.init('ForgotPasswordGolldView')">Forgot password?</span>
            </div>

          </div>
        </div>

      </div>
    """
