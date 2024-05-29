class AdminView extends BaseView
  constructor: ()->
    super("AdminView")

    @template = @tmpl
    # @evtHandler = new AdminEvtHandler(@)

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "SplashView"})

    uid = AppProps.get "uid"
    if uid?
      trace "logged in!"
      UI.views.init "AccountGolldView"

    ctx = @
    $('golldtab').click ->
      if $(this).text() is "Golld"
        trace ""
        ctx.doActive('golldtab', $(this).text(), ctx)
        UI.views.init "SplashView"
      else
        $(this).css "opacity", 0.2
        if window.plugins?
          window.plugins.toast.showShortCenter("!")
        else
          trace "!"

    $('button').click ->
      if $(this).text() is "Anonymous"
        trace "anonymous clicked !"
        UI.views.init "AnonymousCreateView"
      else 
        trace "verified clicked !"
        UI.views.init "VerifiedCreateView"

    $('#loginA').click ->
      UI.views.init "LoginView"

    $('#kycspan').click ->
      $('#helpoverlay').slideDown()
    $('#helpoverlay').click ->
      $('#helpoverlay').slideUp()

  doActive : (tag, text, ctx) ->
    $('body').find(tag).each(->
      if $(this).text() is text
        $(this).html "<strong>" + $(this).text() + "</strong>"
      else
        $(this).html ctx.removeBold($(this).text())
    )

  removeBold : (str) ->
    if str.indexOf "<strong>" is -1
      return str
    else
      str = str.replaceAll "<strong>", ""
      str = str.replaceAll "</strong>", ""
      
  helpOverlayToggle : () ->
    trace "help overlay toggle"

  tmpl: (data) ->
    """
      <!-- <a id='loginA' class='secondary' style='float: right; opacity: 0.3; color: black; padding: 5px;'><strong>Login</strong></a> -->
      <div id='splash'>
          <img src='img/dummy-avatar.png' />
          <h4>Select Account Type</h4>
          <div style='margin-top: 10%;'>
            <button class='button button-full'>Anonymous</button>
            <p>Buy Golld with Ethereum or Credit / Debit Card</p>
            <p>No Personal Information</p>
            <p>Subject to limit of €9,999 or equivalent</p>
          </div>
          <div style='margin-top: 10%;'>
            <button class='button button-full'>Verified</button>
            <p>Buy Golld with Ethereum, Bank Transfer or a Card Payment</p>
            <p><span id="kycspan" style='color: #0a9ec7'>KYC / AML</span> personal info required to purchase more than €10,000 or equivalent</p>
          </div>
      </div>

      <div id='helpoverlay'>
        <p>
          There are laws in place in most jurisdictions to prevent or fight money laundering and other illegal activities.
          Our KYC / AML requirements are necessary to comply with these laws.
        </p>
      </div>

      <div id='footer' class='tabs'>
          <golldtab class='tab-item ion-android-home'>Golld</golldtab>
          <golldtab class='tab-item'>Wallet</golldtab>
      </div>
    """
