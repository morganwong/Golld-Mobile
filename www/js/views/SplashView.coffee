class SplashView extends BaseView
  constructor: ()->
    super("SplashView")

    @template = @tmpl
    @evtHandler = new SplashEvtHandler(@)

  init: (data) =>
    @injectUI({mobileBackBtn : -> navigator.app.exitApp()})

    #TESTING
#    return UI.views.init "BuyLessBuyGolldView"
    #TESTING

#    trace "type of StripeCheckout incoming..."
#    trace typeof StripeCheckout
#    if typeof StripeCheckout is 'undefined'
    trace "type of Stripe incoming..."
    trace typeof Stripe
    if typeof Stripe is 'undefined'
      alert "There is an issue with Stripe on this device..."

    _wallet = @checkForWallet()
    if _wallet?
      AppProps.store "tgwpk", _wallet

      pk = ethUtils.toBuffer _wallet, "hex"
      CWUtils._wallet = ethWallet.fromPrivateKey(pk)
      trace "CWUtils._mywallet incoming..."
      trace CWUtils._wallet
  
      _w = CWUtils._wallet
  
      address = _w.getAddressString()
      trace "Retrieved address !!!"
      trace address

      AppProps.store "tgwaddress", address
      
#    CWUtils._wallet = _wallet

#    ctx = @
#    $('golldtab').click ->
#      if $(this).text() is "Golld"
#        ctx.doActive('golldtab', $(this).text(), ctx)
#      else
#        $(this).css "opacity", 0.2
#        if window.plugins?
#          window.plugins.toast.showShortCenter("!")
#        else
#          trace "!"

    $('label').click ->
      if $(this).text().trim() is "Admin"
        UI.views.init "AdminView"
      if $(this).text().trim() is "Wallet"
        if _wallet is null
          alert "You don't have a wallet yet! Go to 'Admin' to set up."
        else
          UI.views.init "WalletView"

#    $('button').click ->
#      if $(this).text().trim() is "Get Paid"
#        $(this).css "opacity", 0.2
#        if _wallet is null
#          alert "You don't have a wallet yet! Go to 'Admin' to set up."
#        else
#          trace "go to get paid..."
#          UI.views.init "GetPaidView"
#      if $(this).text().trim() is "Pay"
#        $(this).css "opacity", 0.2
#        if _wallet is null
#          alert "You don't have a wallet yet! Go to 'Admin' to set up."
#        else
#          trace "go to pay..."
#          UI.views.init "PayView"
    
    $('#golldpaybutton').click ->
      if CWUtils._wallet is null
        return alert "No Wallet Set Up!"
      UI.views.init "GolldPayView"

    
  checkForWallet : () ->
    trace "checking for wallet..."
    if cordova?

      #TESTING
#      if true
#        return "0x55179df1ca34cc0116a9c7324d1c87377fd9d4486a453b4dee2896eee06b6dc7"
      #END TESTING

      w = AppUtils.getFile("tgwpk")
      trace "w incoming..."
      trace w
      if w is "ERROR"
        return null
      return w
    else
      trace "web test - wallet is 0x55179df1ca34cc0116a9c7324d1c87377fd9d4486a453b4dee2896eee06b6dc7"
      return "0x55179df1ca34cc0116a9c7324d1c87377fd9d4486a453b4dee2896eee06b6dc7"

    return null
          
#  walletInit : () =>
#    $('#loadingspan').html "checking for account..."
#    st = setTimeout(() =>
#      if cordova?
#        currentWallet = AppUtils.getFile("tgwpk")
#      else
#        currentWallet = "0x55179df1ca34cc0116a9c7324d1c87377fd9d4486a453b4dee2896eee06b6dc7"
#        
#      if currentWallet is null
#        trace "currenWallet incoming..."
#        trace currentWallet
#        $('#loadingspan').html "no existing wallet found, creating one..."
#        @genNewWallet()
#      else
#        trace "found wallet !"
#        trace currentWallet
#        AppProps.store "tgwpk", currentWallet
#        $('#loadingspan').html "wallet found, initialising..."
#        @foundWallet()
#    , 1000)
#
#  genNewWallet : () =>
#    trace "in gen new ethWallet..."
#    trace typeof ethWallet
#    trace ethWallet
#    
#    @mywallet = ethWallet.generate()
#
#    if @mywallet?
#      trace "mywallet generated !!!"
#    else
#      trace "problem generating mywallet..."
#      
#    pk = @mywallet.getPrivateKeyString()
#    AppUtils.saveToFile("tgwpk", pk)
#    AppProps.store "tgwpk", pk
#
#    $('#walletpasspopup').slideDown()
#    
#  foundWallet : () =>
#    st = setTimeout(() =>
#      UI.views.init "WalletSplashView"
#    , 1000)
    
#  doActive : (tag, text, ctx) ->
#    $('body').find(tag).each(->
#      if $(this).text() is text
#        $(this).html "<strong>" + $(this).text() + "</strong>"
#      else
#        $(this).html ctx.removeBold($(this).text())
#    )
#
#  removeBold : (str) ->
#    if str.indexOf "<strong>" is -1
#      return str
#    else
#      str = str.replaceAll "<strong>", ""
#      str = str.replaceAll "</strong>", ""

  tmpl: (data) ->
    """
      <div class='bar bar-header'>
        <h1 class='title' id='splashview-header'></h1>
      </div>

      <div class='headerabove'>

        <div id='splash'>
            <img src='img/CoinGollldLogo150px.png' />
            <h2><b>Go</b>ll<b>d</b>.com</h2>
            <h4 style='font-style: italic'>Gold bullion voucher tokens<br>in local currency</h4>
            <hr>
        </div>
        <div class='splashviewbuttons'>

          <div style='width: 100%; padding: 0px; margin: 0px;'>
            <label class='item' style='display: inline; width: 50%; float: left; background-color: #F8F8F8'>
              Admin
              <i class='icon ion-gear-b'></i>
            </label>
            <label class='item' style='display: inline; width: 50%; float: right; background-color: #F8F8F8'>
              Wallet
              <i class='icon ion-card'></i>
            </label>
          </div><br><br><br><br>

          <button class='button button-full button-large' style='color: #d2a23e' id='golldpaybutton'>Golld Pay<i class='icon ion-arrow-right-b'></i></button>
          <!-- <button class='button button-full button-large' style='color: #c58c23' id='golldpaybutton'>Golld Pay<i class='icon ion-arrow-right-b'></i></button>
          <button class='button button-full button-large' style='color: #b07d1c' id='golldpaybutton'>Golld Pay<i class='icon ion-arrow-right-c'></i></button> -->

          <!--<button class='button button-full'>
            Get Paid
            <i class='icon ion-arrow-down-a'></i>
          </button>
          <button class='button button-full button-large'>
            Pay
            <i class='icon ion-arrow-up-a'></i>
          </button> -->
        </div>

        <!-- <div id='footer' class='tabs'>
            <golldtab class='tab-item'>Golld</golldtab>
            <golldtab class='tab-item'>Wallet</golldtab>
        </div> -->

      </div>
    """
