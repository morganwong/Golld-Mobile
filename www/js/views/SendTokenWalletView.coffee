class SendTokenWalletView extends BaseView
  constructor: ()->
    super("SendTokenWalletView")

    @template = @tmpl

  init: (data) =>
#    @injectUI({mobileBackBtn : -> UI.views.init "WalletView"})
    @injectUI({mobileBackBtn : -> UI.views.pop()})
    $('body').css "background-image", "url('img/gatewaybg.jpg')"

    trace "data for Send Token Wallet View incoming..."
    trace data

    which = data.which
    balance = data.obj[which]

    trace "which : "+ which
    trace "balance : " + balance
    trace "from address : " + AppProps.get "tgwaddress"

    $('#which').text which

    if nfc?
      nfc.enabled((s) =>
        trace "nfc enabled success!"
        trace s
      , (f) =>
        trace "nfc enabled failed..."
        trace f
      )

    $('#iqr').click ->
      trace "qr things..."

    # TESTING
    $('#amount').val("1")
    $('#address').val("0xAAd15379235c05bFC897286db3164eccb3ac4082")

    sendObj = {}
    sendObj.token = which
    sendObj.fromAddress = AppProps.get "tgwaddress"
    sendObj.myCurrentBalance = balance
    testingCount = 0
    $('#next').click ->
      amt = $('#amount').val()
      if isNaN(amt) or amt.length < 1
        if testingCount < 1
          alert "Enter a valid amount!"
          testingCount = 1
          return
      sendObj.amount = amt
      add = $('#address').val()
      if add.length < 40 or add.length > 42
        if testingCount < 2
          alert "Enter a valid Ethereum address!"
          testingCount = 2
          return
      sendObj.toAddress = add
      if testingCount is 2
        sendObj.amount = 10
        sendObj.toAddress = "someaddress..."
      UI.views.init "SendTokenConfirmWalletView", {sendObj}

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

        <ul class="list" style='margin: 3%;'>
          <h1 id='which' style='font-weight: bold'></h1>
          <li class='item' style='line-height: 160%'>
            <p style='font-style: italic;'>Enter the amount you want to send</p>
            <label class='item item-input'>
              <input id='amount' type='number' placeholder='Amount To Send'/>
            </label>
          </li>
          <li class='item' style='line-height: 160%'>
            <p style='font-style: italic;'>
              Enter the receiving address<br>
              <font color='red' size='small'>Either by pasting, using nfc, or qr code scanner</font>
            </p>
            <label class='item item-input'>
              <input id='address' type='text' placeholder='Receiving Address'/>
            </label>
            <p>Get Address with NFC **NFC not yet implemented...</p>
            <p>Get Address with qr code <i class='icon ion-android-camera' id="iqr" style='width: 12px; height: auto;'></i></p>
          </li>
          <button id="next" class='button button-block button-assertive' style='float: right; margin-top: 5px;'>Next</button>
        </ul>


      <div id='footer' class='tabs'>
        <golldtab class='tab-item ion-android-home'>Golld</golldtab>
        <golldtab class='tab-item'>Wallet</golldtab>
      </div>

      </div>
    """
