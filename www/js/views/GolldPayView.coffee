class GolldPayView extends BaseView
  constructor: ()->
    super("GolldPayView")

    @template = @tmpl

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "SplashView"})

    $('#golldpay_backbutton').click -> UI.views.init "SplashView"

    #    $('#loadingmsg').text "Looking for wallet..."
    #    loadingcounter = 1
    #    @si = setInterval(() =>
    #      trace "loading..."
    #      trace "counter is " + loadingcounter
    #      @loadingLine(loadingcounter++)
    #    , 500)

    privateKey = AppProps.get "tgwpk"
    trace "private key is " + privateKey
    pk = ethUtils.toBuffer privateKey, "hex"

    CWUtils._wallet = ethWallet.fromPrivateKey(pk)
    trace "CWUtils._mywallet incoming..."
    trace CWUtils._wallet

    _w = CWUtils._wallet

    address = _w.getAddressString()
    trace "Retrieved address !!!"
    trace address
    AppProps.store "tgwaddress", address

    #    trace "default address incoming..."
    #    trace ethWallet.defaultAddress
    #    ethWallet.defaultAddress = address
    #    trace ethWallet.defaultAddress

    $('#address').text address

    CWUtils._web3 = new Web3(new Web3.providers.HttpProvider("#{AppProps.geth}"));
    trace "CWUtils._web3 incoming..."
    trace typeof CWUtils._web3
    trace CWUtils._web3

    balance = CWUtils._web3.eth.getBalance address
    trace "balance incoming..."
    trace balance
    balance = balance.toNumber() + ""
    trace balance
    if balance is "0"
      $('#balanceh1').text "0 ETH"
    else
      b = balance.substring(0, balance.length - 18) # 18 decimal places for Ether
      b = b + "." + balance.substring(1)
      $('#balanceh1').text b + " ETH"

    #    bgimgurl = "https://golldcore.herokuapp.com/qr/get/" + address
    bgimgurl = AppProps.qrcodeep + address
    $('#qrimg').attr "src", bgimgurl
    $('#qrdivaddress').text address

    $('#qrdiv').click ->
      $('#qrdiv').slideUp(200)

    $('.walletaddressicons i').click ->
      whichid = $(this).attr("id")
      switch $(this).attr("id").substring(1)
        when "copy"
          if window.plugins?
            window.plugins.toast.showShortCenter("Address copied to clipboard!")
            cordova.plugins.clipboard.copy(address);
          else
            $temp = $("<input>")
            $("body").append($temp)
            $temp.val($('#address').text()).select()
            document.execCommand("copy")
            $temp.remove()
            trace "after copy..."
        when "qr"
          trace "qr!"
          $('#qrdiv').slideDown(200)
        when "forward"
          trace "forward!"
          #          social sharing !
          #          https://github.com/EddyVerbruggen/SocialSharing-PhoneGap-Plugin
          # this is the complete list of currently supported params you can pass to the plugin (all optional)
          options = {
            message: address, # not supported on some apps (Facebook, Instagram)
            subject: "Ethereum Address", # fi. for email
            files: ['', ''], # an array of filenames either locally or remotely
#            url: 'https:#www.website.com/foo/#bar?a=b',
            chooserTitle: 'Pick an app' # Android only, you can override the default share sheet title,
#            appPackageName: 'com.apple.social.facebook' # Android only, you can provide id of the App you want to share with
          }

          onSuccess = (result) ->
            console.log("Share completed? " + result.completed); # On Android apps mostly return false even while it's true
            console.log("Shared to app: " + result.app); # On Android result.app since plugin version 5.4.0 this is no longer empty. On iOS it's empty when sharing is cancelled (result.completed=false)


          onError = (msg) ->
            console.log("Sharing failed with message: " + msg)

          window.plugins.socialsharing.shareWithOptions(options, (result) ->
            trace "Share completed? " + result.completed
            trace "Shared to app: " + result.app
          , (msg) ->
            trace "Sharing failed with message: " + msg
          )

    tokenAndBalanceObj = {}

    #    if cordova?
    #      currentTokens = AppUtils.getFile("tgwtokens")
    #    else
    #      currentTokens = "{\"golldvouchers\":{\"EuroGolld\":true}}"
    currentTokens = "{\"golldvouchers\":{\"EuroGolld\":true}}"

    trace "current tokens incoming..."
    trace currentTokens
    if currentTokens is null
      $('#tokenslist').html "None"
    else
      currentTokens = JSON.parse currentTokens
      if currentTokens.golldvouchers?
        trace "current tokens dot golldvouchers isnt null or undefined !!!"
        txobj = {}
        for k of currentTokens.golldvouchers
          trace k
          if currentTokens.golldvouchers[k]
            txobj.to = AppProps.contracts[k]
            bo = ethUtils.sha3('balanceOf(address)')
            bo = ethUtils.bufferToHex(bo)
            bo = bo.substring(0, 10)
            txobj.data = bo + "000000000000000000000000" + address.substring(2)
            res = CWUtils._web3.eth.call(txobj)
            bal = CWUtils._web3.toBigNumber res
            bal = CWUtils._web3.fromWei(bal.toNumber())
            tokenAndBalanceObj[k] = bal
            trace tokenAndBalanceObj
            trace "Balance of " + k + " tokens is " + bal
            $('#tokenslist').html k + ": <span id='" + k + "_amountspan'>" + bal + ""

    $('#addtokenbutton').click ->
      trace "Add Token button clicked !!!"
      UI.views.init "AddTokenWalletView"

    $('i').click ->
      which = $(this).attr("id")
      trace tokenAndBalanceObj
      if which.indexOf("send_") isnt -1
        UI.views.init "SendTokenWalletView", {which : which.substring(5), obj : tokenAndBalanceObj}



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

  loadingLine : (lc) =>
    switch lc
      when 1 then $('#loadingmsg').text "None found.. generating new wallet..."
      when 2 then $('#loadingmsg').text "Done!"
      when 3
        $('.loadingoverlay').slideUp()
        clearInterval(@si)
        trace "INTERVAL CLEARED !!!"

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

  tmpl: (data) ->
    """
      <div class='bar bar-header bar-stable'>
        <button class="button button-icon icon ion-chevron-left" id="golldpay_backbutton"></button>
        <h1 class="title">Golld Pay</h1>
      </div>

      <div id='walletcontent' class='splash headerabove'>

        <ul class="list">
          <li class="item" style='line-height: 160%'>
            <span>Your Wallet Address</span>
            <p id='address'></p>
          </li>
          <li class='item' style='line-height: 160%'>
            <span>Tokens</span>
            <ul class='list'>
              <li class='item' id='tokenslist'>
              </li>
            </ul>
          </li>
        </ul>

        <button class='button button-full button-large' style='color: #d2a23e'>Make Payment<i class='icon ion-arrow-right-b' style='position: absolute; float: right; right: 10%;'></i></button>
        <button class="button button-large button-full" style='color: #d2a23e'>Take Payment<i class='icon ion-arrow-left-b' style='position: absolute; float: left; left: 10%;'></i></button>

      </div>


      <div id='footer' class='tabs'>
        <golldtab class='tab-item ion-android-home'>Golld</golldtab>
        <golldtab class='tab-item'>Wallet</golldtab>
      </div>
    """
