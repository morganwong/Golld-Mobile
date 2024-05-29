class AnonymousCreateView extends BaseView
  constructor: ()->
    super("AnonymousCreateView")

    @template = @tmpl
    # @evtHandler = new AnonymousCreateEvtHandler(@)

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "AdminView"})

    trace "CW utils . wallet incoming..."
    trace CWUtils._wallet
    if CWUtils._wallet?
      @mywallet = CWUtils._wallet
    else
      @mywallet = null

    if @mywallet is null
      $('#needwalletp').css "display", "block"
      $('#walletbutton').text "Create Wallet"

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

    ctx = @
    $('button').click ->
      if $(this).text() is "Wallet" or $(this).text() is "Create Wallet"
        trace "wallet clicked !"
        # Create Private Key here
        if ctx.mywallet is null
          ctx.walletInit()
          window.plugins.toast.showShortCenter("Wallet creation successful!")
        UI.views.init "WalletView"
      else if $(this).text() is "Buy Golld"
        trace "buy golld clicked !"
        $(this).css "opacity", 0.2
        trace "ctx dot mywallet incoming..."
        trace ctx.mywallet
        if ctx.mywallet is null
          if window.plugins?
            window.plugins.toast.showShortCenter("You need a wallet first!")
          else
            alert "You need a wallet first!"
        else
          trace "go to buy golld..."
#          window.plugins.toast.showShortCenter("go to buy golld...")
          UI.views.init "BuyLessGolldView"

    $('span').click ->
      sid = $(this).attr("id")
      $('#helpoverlay').find('p').each(() ->
        if $(this).attr("id") is sid + "text"
          $(this).show()
        else
          $(this).hide()
      )
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

  walletInit : () =>
    trace "in wallet init !!!"
    @mywallet = ethWallet.generate()

    if @mywallet?
      trace "mywallet generated !!!"
    else
      trace "problem generating mywallet..."

    pk = @mywallet.getPrivateKeyString()
    AppUtils.saveToFile("tgwpk", pk)
    AppProps.store "tgwpk", pk

  tmpl: (data) ->
    """
      <div id='splash'>
          <img src='img/dummy-avatar.png' />
          <h4>Anonymous</h4>
          <p>
            Golld has no personal info, even if you use your credit / debit card (card processor gets this info).
            Buy with <span id='cashhelp' style='color: #0a9ec7'>cash</span>, <span id='ethereumhelp' style='color: #0a9ec7'>Ethereum</span>
            , or <span id='cardhelp' style='color: #0a9ec7'>card</span>.
          </p>
          <div style='margin-top: 10%;'>
            <button class='button button-full' id='walletbutton'>Wallet</button>
            <p id="needwalletp" style='font-style: italic; display: none;'>You need a wallet!</p>
          </div>
          <div style='margin-top: 10%;'>
            <button class='button button-full'>Buy Golld</button>
          </div>
      </div>

      <div id='helpoverlay'>
        <p id='cashhelptext' style='display:none;'>
          You can call into our offices to purchase vouchers with cash if you wish! Call 1234567890 for more info.
        </p>
        <p id='ethereumhelptext' style='display:none;'>
          You can use <a href='www.ethereum.org'>Ethereum</a> to purchase Golld vouchers!
        </p>
        <p id='cardhelptext' style='display:none;'>
          We use <a href='www.stripe.com'>Stripe</a> to process all card transactions.
        </p>
      </div>

      <div id='footer' class='tabs'>
          <golldtab class='tab-item ion-android-home'>Golld</golldtab>
          <golldtab class='tab-item'>Wallet</golldtab>
      </div>
    """
