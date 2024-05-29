class AddTokenWalletView extends BaseView
  constructor: ()->
    super("AddTokenWalletView")

    @template = @tmpl

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.pop()})
    $('body').css "background-image", "url('img/gatewaybg.jpg')"
    
    trace "CWUtils._mywallet incoming..."
    trace CWUtils._wallet
    
    trace "address incoming..."
    address = CWUtils._wallet.getAddressString()
    trace address

    trace "CWUtils._web3 incoming..."
    trace CWUtils._web3

    currentTokens = AppUtils.getFile("tgwtokens")
    trace "current tokens incoming..."
    trace currentTokens
    if currentTokens is null
      currentTokens = {}
      currentTokens.golldvouchers = {}
    else
      currentTokens = JSON.parse currentTokens

    $('#addeurogolldbutton').click =>
      if currentTokens.golldvouchers.EuroGolld
        window.plugins.toast.showShortCenter("EuroGolld tokens have already been added your wallet")
      else
        currentTokens.golldvouchers.EuroGolld = true
        AppUtils.saveToFile("tgwtokens", JSON.stringify currentTokens)
        window.plugins.toast.showShortCenter("EuroGolld token added to your wallet!")

    $('#adddollargolldbutton').click =>
      if currentTokens.golldvouchers.DollarGolld
        window.plugins.toast.showShortCenter("DollarGolld tokens have already been added your wallet")
      else
        currentTokens.golldvouchers.DollarGolld = true
        AppUtils.saveToFile("tgwtokens", JSON.stringify currentTokens)
        window.plugins.toast.showShortCenter("DollarGolld token added to your wallet!")

    $('#addpoundgolldbutton').click =>
      if currentTokens.golldvouchers.PoundGolld
        window.plugins.toast.showShortCenter("PoundGolld tokens have already been added your wallet")
      else
        currentTokens.golldvouchers.PoundGolld = true
        AppUtils.saveToFile("tgwtokens", JSON.stringify currentTokens)
        window.plugins.toast.showShortCenter("PoundGolld token added to your wallet!")

    $('#addtokenbutton').click =>
      trace "add token button..."
      window.plugins.toast.showShortCenter("Coming soon...")
    $('#contractaddressinput').click =>
      trace "contract address input..."
      window.plugins.toast.showShortCenter("Coming soon...")

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

  tmpl: (data) ->
    """
      <div class="has-header">

        <ul class="list">
          <li class='item' style='line-height: 160%'>
            <h1><strong>Tokens</strong></h1>
            <p style='font-style: italic;'>Enter contract address below to add token</p>
            <label class='item item-input'>
              <input id='contractaddressinput' type='text' placeholder='Contract Address'/>
            </label>
            <button id="addtokenbutton" class='button button-assertive' style='float: right; margin-top: 5px;'>Add Token</button>
          </li>
          <li class='item' style='line-height: 160%'>
            <h2><strong>Golld Vouchers</strong></h2>
            <div>
              <button id="addeurogolldbutton" class='button button-block button-stable'>Add EuroGolld</button>
              <button id="adddollargolldbutton" class='button button-block button-stable'>Add DollarGolld</button>
              <button id="addpoundgolldbutton" class='button button-block button-stable'>Add PoundGolld</button>
            </div>
          </li>
        </ul>

      <div id='footer' class='tabs'>
        <golldtab class='tab-item ion-android-home'>Golld</golldtab>
        <golldtab class='tab-item'>Wallet</golldtab>
      </div>

      </div>
    """
