class BuyLessGolldView extends BaseView
  constructor: ()->
    super("BuyLessGolldView")

    @template = @tmpl
    @evtHandler = new BuyLessEvtHandler(@)
    @evtHandler.net.bindEvtToLink "buyless", NetEvtLinks.rest.OrderController.buyless

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.pop()})

    preparecb = (e, s) =>
      trace "IN PREPARE CB !!!"
      trace e
      trace JSON.stringify s

    QRScanner.prepare(preparecb)

    $('i').click =>
      trace "i clicked !!!"
      trace $('body').css('background-color')
      QRScanner.show( () =>
        trace 'Starting scan...'
        $('body').hide()
        QRScanner.scan( (err, result) =>
          $('body').show()
          if(err)
            trace err
            trace 'Scan canceled successfully.'
            trace 'Destroying QRScanner...'
            QRScanner.destroy( (status) =>
              trace 'QRScanner destroyed. Status:'
              trace status

            )

          else
            trace result
            address = result.substring 9
            trace address
            $('#address').val(address)
            # result is "ethereum:0xaad15379235c05bfc897286db3164eccb3ac4082"
            QRScanner.hide( (status) =>
              trace 'QRScanner destroyed. Status:'
              trace status
            )
            QRScanner.destroy( (status) =>
              trace 'QRScanner destroyed. Status:'
              trace status
              trace $('body').css('background-color')
            )
        )
      )

    order = {}

    $('#amount').on "input", () ->
      if isNaN($(this).val())
        $(this).val ""
        alert "You can only enter numbers in the 'Amount' field!"

    $('button').click =>
      order.voucher = $('#voucher').val()
      order.amount = $('#amount').val()
      order.paymentmethod = $('#paymentmethod').val()
      order.address = $('#address').val()

      if order.voucher is ""
        return alert "Select which voucher to buy!"
      if order.paymentmethod isnt "stripe"
        $('#paymentmethod').val "stripe"
        return alert "Only Credit or Debit card payments can be accepted at this time"
      if order.amount.length < 1
        return alert "Enter a valid amount"
      #      if order.address.length < 40
      if order.address.length < 4
        return alert "Enter a valid address"

      trace "order incoming..."
      trace JSON.stringify order

      AppProps.store "order", JSON.stringify order

      @evtHandler.net.urlParams({
        whichcurrency : order.voucher
        amount : order.amount
        paymentmethod : order.paymentmethod
        ethaddress : order.address
      }).post "buyless"


    $('#address').val AppProps.get "tgwaddress"

    ctx = @
    $('golldtab').click ->
      if $(this).text() is "Golld"
        trace ""
        UI.views.init "SplashView"
      else
        $(this).css "opacity", 0.2
        if window.plugins?
          window.plugins.toast.showShortCenter("!")
        else
          trace "!"


  tmpl: (data) ->
    """
      <div class="has-header">
        <div class='padding5'>

          <h4 style='font-style: italic'>Buy Golld Vouchers - no fuss, no sign ups</h4>

          <div class=''>
            <label class='item item-input item-select'>
              <div style='text-align: left; color: grey' class="input-label">
                Select voucher
              </div>
              <select id='voucher'>
                <option value=''>Select voucher to buy</option>
                <option value='eurogolld'>EuroGolld</option>
                <option value='dollargolld'>DollarGolld</option>
                <option value='poundgolld'>PoundGolld</option>
              </select>
            </label>
            <label class='item item-input'>
              <input id='amount' type='text' placeholder='Amount to purchase'/>
            </label>
            <label class='item item-input item-select'>
              <div style='text-align: left; color: grey' class="input-label">
                Payment method
              </div>
              <select id='paymentmethod'>
                <option value=''>Select payment method</option>
                <option value='stripe'>Credit / Debit card</option>
                <option value='banktransfer'>Bank Transfer</option>
                <option value='cryptocurrency'>Crypto Currency</option>
              </select>
            </label>
            <label class='item item-input'>
              <input id='address' type='text' placeholder='Your Ethereum Address'/> <!-- <i class="button icon ion-camera"></i> -->
            </label>

            <button class='button button-block button-dark' style='margin-top: 30px'>Continue</button>
          </div>



        </div>
      </div>

          <div id='footer' class='tabs'>
            <golldtab class='tab-item ion-android-home'>Golld</golldtab>
            <golldtab class='tab-item'>Wallet</golldtab>
          </div>
    """
