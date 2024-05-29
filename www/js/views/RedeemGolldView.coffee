class RedeemGolldView extends BaseView
  constructor: ()->
    super("RedeemGolldView")

    @template = @tmpl
    @evtHandler = new RedeemGolldEvtHandler(@)
    @evtHandler.net.bindEvtToLink "accountorder", NetEvtLinks.rest.OrderController.accountorder

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "AccountGolldView"})
    $('back').click ->
      UI.views.init('AccountGolldView')
    $('logout').click ->
      AppProps.logout()
      if AppProps.uid is null
        UI.views.init('SplashView')
      else
        trace " in else at logout "
        return alert " Unexpected error "

    data = JSON.parse(AppProps.get("accdata"))
#    preparecb = (e, s) =>
#      trace "IN PREPARE CB !!!"
#      trace e
#      trace JSON.stringify s

#    QRScanner.prepare(preparecb)
#
#    $('i').click =>
#      trace "i clicked !!!"
#      trace $('body').css('background-color')
#      QRScanner.show( () =>
#        trace 'Starting scan...'
#        $('body').hide()
#        QRScanner.scan( (err, result) =>
#          $('body').show()
#          if(err)
#            trace err
#            trace 'Scan canceled successfully.'
#            trace 'Destroying QRScanner...'
#            QRScanner.destroy( (status) =>
#              trace 'QRScanner destroyed. Status:'
#              trace status
#
#            )
#
#          else
#            trace result
#            address = result.substring 9
#            trace address
#            $('#address').val(address)
#            # result is "ethereum:0xaad15379235c05bfc897286db3164eccb3ac4082"
#            QRScanner.hide( (status) =>
#              trace 'QRScanner destroyed. Status:'
#              trace status
#            )
#            QRScanner.destroy( (status) =>
#              trace 'QRScanner destroyed. Status:'
#              trace status
#              trace $('body').css('background-color')
#            )
#        )
#      )

    order = {}
    $('#paymentmethod').on "change", () ->
      if $('#paymentmethod').val() is "userfunds"
        $('#currency').html data.currency
        $('#currencycontainer').show()
      else
        $('#currency').html " "
        $('#currencycontainer').hide()
    $('#amount').on "input", () ->
      trace "in amount"
      if isNaN($(this).val())
        $(this).val ""
        alert "You can only enter numbers in the 'Amount' field!"
      if data.allKycApproved is false
        $(this).attr('max', '9999')
        if $('#amount').val() > 9999
          trace " bigger than "
          $('#amount').val ''
          $('#warning').show()
          $('#warning').css('color','red')
          return alert "Enter a valid amount"

    $('button').click =>
      trace " in button "
      order.voucher = $('#voucher').val()
      order.amount = $('#amount').val()
      order.paymentmethod = $('#paymentmethod').val()
      order.address = $('#address').val()
      trace order.paymentmethod

      if order.amount.length < 1
        return alert "Enter a valid amount"
      #      if order.address.length < 40
      if order.address.length < 4
        return alert "Enter a valid address"
      if order.amount is '0'
        return alert "Amount cant be 0"
      if data.allKycApproved is false
        if order.amount.length > 4
          return alert "Enter a valid amount"

      trace "order incoming..."
      trace JSON.stringify order

      AppProps.store "order", JSON.stringify order

      @evtHandler.net.urlParams({
        uid: AppProps.uid
        whichcurrency : order.voucher
        amount : order.amount
        paymentmethod : order.paymentmethod
        ethaddress : order.address
      }).post "accountorder"


  tmpl: (data) ->
    """
       <div class='bar bar-header bar-light'>
        <back class='button'>Back</back>
        <h4 style='font-style: italic' class='title'>Buy Golld Vouchers</h4>
        <logout class='button'>Logout</logout>
      </div>
      <div class="has-header">

        <div class='padding5'>

          <div class='content2 content'>

            <b><p id='warning' style='display:none;'>You can't buy more than 9999 while your account is not approved</p></b>
            <div id='currencycontainer' class="card" style='display:none;'>
              <div class="item item-divider">
                Currency used to pay
              </div>
              <div id="currency" class="item item-text-wrap">
              </div>
            </div>
            <label class='item item-input item-select'>
              <div style='text-align: left; color: grey' class="input-label">
                Select voucher to buy
              </div>
              <select id='voucher'>
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
                Select payment method
              </div>
              <select id='paymentmethod'>
                <option value='stripe'>Credit / Debit card</option>
                <option value='banktransfer'>Bank Transfer</option>
                <option value='userfunds'>Funds</option>
                <option value='cryptocurrency'>Crypto Currency</option>
              </select>
            </label>
            <label class='item item-input'>
              <input id='address' type='text' placeholder='Your Ethereum Address'/> <i class="button icon ion-camera"></i>
            </label>
            <p id='warningcurrency'></p>
            <button class='button button-large button-dark' style='margin-top: 30px'>Continue</button>
          </div>


        </div>

      </div>
    """