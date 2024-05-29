class SplashView_OLD extends BaseView
  constructor: ()->
    super("SplashView_OLD")

    @template = @tmpl
    @evtHandler = new SplashEvtHandler(@)

  init: (data) =>
    @injectUI({mobileBackBtn : -> navigator.app.exitApp()})

    trace "type of StripeCheckout incoming..."
    trace typeof StripeCheckout
    if typeof StripeCheckout is 'undefined'
      alert "There is an issue with Stripe on this device..."

    ctx = @
    $('golldtab').click ->
      $('#splash').slideUp()
      if $(this).text() is "Golld"
        $('#golldtab').slideDown()
        $('#wallettab').slideUp()
      else
        $('#wallettab').slideDown()
        $('#golldtab').slideUp()
        ctx.walletInit()

      ctx.doActive('golldtab', $(this).text(), ctx)

    $('#walletpasspopup button').click ->
      trace "Create password clicked !"
      pass = $('#passinput').val()
      $('#passhere').text pass
      $('#pinhere').text CWUtils.generatePin()
      $('#walletpasspopup').hide()
      $('#walletpinpopup').slideDown()

    $('#walletpinpopup button').click ->
      trace "OK clicked !"
      UI.views.init "WalletSplashView"

  walletInit : () =>
    $('#loadingspan').html "checking for account..."
    st = setTimeout(() =>
      if cordova?
        currentWallet = AppUtils.getFile("tgwpk")
      else
        currentWallet = "0x55179df1ca34cc0116a9c7324d1c87377fd9d4486a453b4dee2896eee06b6dc7"
        
      if currentWallet is null
        trace "currenWallet incoming..."
        trace currentWallet
        $('#loadingspan').html "no existing wallet found, creating one..."
        @genNewWallet()
      else
        trace "found wallet !"
        trace currentWallet
        AppProps.store "tgwpk", currentWallet
        $('#loadingspan').html "wallet found, initialising..."
        @foundWallet()
    , 1000)

  genNewWallet : () =>
    trace "in gen new ethWallet..."
    trace typeof ethWallet
    trace ethWallet
    
    @mywallet = ethWallet.generate()

    if @mywallet?
      trace "mywallet generated !!!"
    else
      trace "problem generating mywallet..."
      
    pk = @mywallet.getPrivateKeyString()
    AppUtils.saveToFile("tgwpk", pk)
    AppProps.store "tgwpk", pk

    $('#walletpasspopup').slideDown()
    
  foundWallet : () =>
    st = setTimeout(() =>
      UI.views.init "WalletSplashView"
    , 1000)
    
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
      <div class="has-header">

        <div id='splash'>
          <img src='img/CoinGollldLogo150px.png'/>
          <p>Opening Message Here...</p>
        </div>
        <div class='content'>
        <div id='golldtab'>
          <div class='padding10'>
            <img src='img/CoinGollldLogo150px.png'/>
            <h2>Welcome to Golld</h2>
            <h4 style='font-style: italic'>Own Gold bullion, without buying a vault</h4>
            <hr>
          </div>

          <button class='button button-full button-dark' onclick="UI.views.init('LoginCreateGolldView')">Login / Create Account</button>
          <button class='button button-full button-dark' onclick="UI.views.init('BuyLessGolldView')">Buy Golld</button>
          <button class='button button-full button-dark'>Info</button>
          </div>
        </div>

        <div id='wallettab'>
          <img id="wallettab_loadingimg" src='img/loading.svg'/>
          <p><span id='loadingspan'></span></p>

          <div id='walletpasspopup' class='padding10'>
            <div id='createpassworddiv'>
              <h4>Choose a password for your wallet</h4>
              <label class='item item-input'>
                <input id='passinput' type='text' placeholder='password'/>
              </label>
              <button class='button button-large button-dark' style='margin-top: 10px'>Create</button>
            </div>
          </div>
        </div>

        <div id='walletpinpopup' class='padding10'>
          <p style='color: red; font-style: italic'>
            Make sure you record your password and pin! <br>
            No other record of these is kept, and you will need these to access your wallet.
          </p>
          <h4>Your Password:</h4>
          <h2 id='passhere'></h2>
          <br>
          <h4>Your PIN:</h4>
          <h2 id='pinhere'></h2>
          <br>
          <button class='button button-large button-dark'>OK</button>
        </div>

        <div id='footer' class='tabs'>
          <golldtab class='tab-item'>Golld</golldtab>
          <golldtab class='tab-item'>Wallet</golldtab>
        </div>

      </div>
    """
