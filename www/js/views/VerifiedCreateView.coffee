class VerifiedCreateView extends BaseView
  constructor: ()->
    super("VerifiedCreateView")

    @template = @tmpl
    # @evtHandler = new VerifiedCreateEvtHandler(@)

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "AdminView"})

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
      if $(this).text() is "Create Account"
        trace "create account clicked !"
      else if $(this).text() is "Login"
        trace "login clicked !"
        UI.views.init "LoginView"
    
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

  tmpl: (data) ->
    """
      <div id='splash'>
          <img src='img/dummy-avatar.png' />
          <h4>Verified</h4>
          <p>
            Very little personal info required initially, but KYC / AML 
            (Know Your Customer / Anti Money Laundering) law applies to purchases over €10,000 or equivalent.
            Password recovery only available on verified accounts.
          </p>
          <div style='margin-top: 10%;'>
            <button class='button button-full'>Create Account</button>
            <p>~ OR ~</p>
            <button class='button button-full'>Login</button>
          </div>
      </div>

      <div id='footer' class='tabs'>
          <golldtab class='tab-item'>Golld</golldtab>
          <golldtab class='tab-item'>Wallet</golldtab>
      </div>
    """
