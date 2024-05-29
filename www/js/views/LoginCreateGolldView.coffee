class LoginCreateGolldView extends BaseView
  constructor: ()->
    super("LoginCreateGolldView")

    @template = @tmpl
    @evtHandler = new LoginCreateGolldEvtHandler(@)
    @evtHandler.net.bindEvtToLink 'login', NetEvtLinks.rest.AccountController.login
    @evtHandler.net.bindEvtToLink 'create', NetEvtLinks.rest.AccountController.create

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "SplashView"})

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
    @evtHandler.net.body({
      username : $('#loginusername').val()
      password : $('#loginpassword').val()
    }).post "login"

  create : () =>
    @evtHandler.net.body({
      username : $('#createusername').val()
      email : $('#createemail').val()
      password : $('#createpassword').val()
      confirmpassword : $('#createconfirmpassword').val()
      acctype : $('#createacctype').val()
    }).post "create"
    alert('Account Created')
    $('#createform').hide()
    $('#loginform').show()

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
            <p><em>~ OR ~</em></p>
            <button class='button button-full button-dark' id='switchtocreatebutton'>Create Account</button>
          </div>

          <div id='createform' style='display:none'>
            <label class='item item-input'>
              <input id='createusername' type='text' placeholder='Username'/>
            </label>
            <label class='item item-input'>
              <input id='createemail' type='email' placeholder='Email'/>
            </label>
            <label class='item item-input'>
              <input id='createpassword' type='password' placeholder='Password'/>
            </label>
            <label class='item item-input'>
              <input id='createconfirmpassword' type='password' placeholder='Confirm Password'/>
            </label>
            <label class='item item-input item-select'>
              <div style='text-align: left; color: grey' class="input-label">
                Account Type
              </div>
              <select id='createacctype'>
                <option value='individual'>INDIVIDUAL</option>
                <option value='company'>COMPANY</option>
              </select>
            </label>
            <button class='button button-full button-dark' id='createaccountbutton'>Create Account</button>
            <p><em>~ OR ~</em></p>
            <button class='button button-full button-dark' id='switchtologinbutton'>Login</button>
          </div>
            
          </div>
        </div>

      </div>
    """
