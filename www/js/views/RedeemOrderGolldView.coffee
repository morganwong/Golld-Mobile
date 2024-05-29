class RedeemOrderGolldView extends BaseView
  constructor: ()->
    super("RedeemOrderGolldView")

    @template = @tmpl
    @evtHandler = new RedeemOrderEvtHandler(@)
    @evtHandler.net.bindEvtToLink "makeaccountorder", NetEvtLinks.rest.OrderController.makeaccountorder

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "RedeemGolldView"})
    data = JSON.parse(AppProps.get("accdata"))
    trace data.currency
    order = AppProps.get "order"
    trace "order incoming..."
    trace order
    order = JSON.parse order
    trace order
    trace order.order.paymenttype
    $('#voucher').html order.order.whichcurrency
    $('#amount').html order.order.amountordered
    $('#ethereumaddress').html order.order.ethaddress
    $('#currency').html data.currency
    switch order.order.paymenttype
      when "stripe"
        $('#paymentmethod').html "Credit / Debit card"
      when "userfunds"
        $('#paymentmethod').html "User Funds"
        $('#currencycontainer').show()
      when "banktransfer"
        trace ""
      when "cryptocurrency"
        trace ""
      else
        trace "ERROR in switch..."

    $('#amount').on "input", () ->
      if isNaN($(this).val())
        $(this).val ""
        alert "You can only enter numbers in the 'Amount' field!"

    $('button').click =>
      if order.order.paymenttype is "stripe"
        handler.open({
          name: "Golld",
          description: "Payment",
          amount: order.amount * 100
        })
      else if order.order.paymenttype is "userfunds"
        @evtHandler.net.urlParams({
          orderid : order.order.id
          fundcurrency : data.currency
          token : order.gvs_token
        }).post "makeaccountorder"

    window.addEventListener("popstate", () ->
      handler.close()
    )

    handler = StripeCheckout.configure({
      key: 'pk_test_6pRNASCoBOKtIshFeQd4XMUh',
      image: 'https://golldvouchers.herokuapp.com/img/CoinGollldLogo150px.png',
      locale: 'auto',
      token: (token) =>
        trace "In TOKEN function !! token incoming..."
        trace token
        trace token.id

        $('button').prop("disabled", "true")
        @evtHandler.net.urlParams({
          orderid : order.order.id
          st : token.id
          token : order.gvs_token
        }).post "makeaccountorder"
    })

  tmpl: (data) ->
    """
      <div class="has-header">
        <div class='padding5'>

          <h3>Confirm Order:</h3>
          <h4>Make sure you have supplied the correct Ethereum address!</h4>
          <div id='currencycontainer' class="card" style='display:none;'>
            <div class="item item-divider">
              Currency used to pay
            </div>
            <div id="currency" class="item item-text-wrap">
            </div>
          </div>
          <div class="card">
            <div class="item item-divider">
              Voucher
            </div>
            <div id="voucher" class="item item-text-wrap">
            </div>
          </div>
          <div class="card">
            <div class="item item-divider">
              Amount
            </div>
            <div id="amount" class="item item-text-wrap">
            </div>
          </div>
          <div class="card">
            <div class="item item-divider">
              Payment Method
            </div>
            <div id="paymentmethod" class="item item-text-wrap">
            </div>
          </div>
          <div class="card">
            <div class="item item-divider">
              Receiving Ethereum Addresss
            </div>
            <div id="ethereumaddress" class="item item-text-wrap">
            </div>
          </div>

          <button class='button button-large button-dark' style='margin-top: 30px'>Buy</button>

        </div>
      </div>
    """
