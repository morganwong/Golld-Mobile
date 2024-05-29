class FundMoreView extends BaseView
  constructor: ()->
    super("FundMoreView")

    @template = @tmpl
    @evtHandler = new FundMoreEvtHandler(@)
    @evtHandler.net.bindEvtToLink "fundaccount", NetEvtLinks.rest.AccountController.fundaccount

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "FundGolldView"})
    $('back').click ->
      UI.views.init('AccountGolldView')
    $('logout').click ->
      AppProps.logout()
      if AppProps.uid is null
        UI.views.init('SplashView')
      else
        return alert 'unexpected error'
    preparecb = (e, s) =>
      trace "IN PREPARE CB !!!"
      trace e
      trace JSON.stringify s

    data = JSON.parse(AppProps.get("accdata"))
    $('#currency').text data.currency
    trace data
# Security Check //////////////////////////////////
    if data.allKycApproved is false
      alert ' error account not approved '
      UI.views.init "FundGolldView"
# ////////////////////////////////////////////////
    $('#amount').on "input", () ->
      if isNaN($(this).val())
        $(this).val ""
        alert "You can only enter numbers in the 'Amount' field!"

    $('button').click =>
      order.currency = data.currency
      order.amount = $('#amount').val()
      order.paymentmethod = $('#paymentmethod').val()
      order.amountbracket = 'less'
      order.uid = AppProps.uid
      if order.paymentmethod isnt "stripe"
        $('#paymentmethod').val "stripe"
        return alert "Only Credit or Debit card payments can be accepted at this time"
      if order.amount.length < 1
        return alert "Enter a valid amount"
      #      if order.address.length < 40
      if order.amount is '0'
        return alert "Amount cant be 0"

      trace "order incoming..."
      trace JSON.stringify order

      AppProps.store "fundorder", JSON.stringify order

      @evtHandler.net.urlParams({
        uid : order.uid
        amountbracket : order.amountbracket
        fundmethod : order.paymentmethod
      }).post "fundaccount"
    $('#currency').text data.currency



  tmpl: (data) ->
    """
       <div class='bar bar-header bar-light'>
        <back class='button'>Back</back>
        <h1 class='title'>Fund your account</h1>
        <logout class='button'>Logout</logout>
      </div>
      <div class="has-header content content2">

        <div class='padding5'>

          <h4 style='font-style: italic'>Add funds to your account</h4>

          <div class=''>
            <label class='item item-input'>
              <div>Currency:</div>
              <p id='currency'></p>
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
                <option value='cryptocurrency'>Crypto Currency</option>
              </select>
            </label>
            <button class='button button-large button-dark' style='margin-top: 30px'>Continue</button>
          </div>


        </div>

      </div>
    """
