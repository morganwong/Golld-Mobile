class BuyLessCompleteGolldView extends BaseView
  constructor: ()->
    super("BuyLessCompleteGolldView")

    @template = @tmpl
    @evtHandler = new BuyLessCompleteEvtHandler(@)
    @evtHandler.net.bindEvtToLink "getorder", NetEvtLinks.rest.OrderController.getorder

  init: (data) =>
    @injectUI({mobileBackBtn : ->
      trace ""
    })

    @order = AppProps.get "order"
    trace "got order..."
    trace @order
    @order = JSON.parse @order
    trace @order
    
    @oid = AppProps.get "orderid"

    @evtHandler.net.urlParams({
      oid : @oid
    }).get "getorder"

    $('#email').click ->
      alert "coming soon..."

  filldetails : (data) =>
    trace data
    $('#voucher').html data.whichCurrency
    $('#amount').html data.amountOrdered
    $('#ethereumaddress').html data.ethAddress
    $('#orderid').html data.orderNumber
    switch data.paymentType
      when "stripe"
        $('#paymentmethod').html "Credit / Debit card"
      when "banktransfer"
        trace ""
      when "cryptocurrency"
        trace ""
      else
        trace "ERROR in switch..."

  tmpl: (data) ->
    """
      <div class="has-header">
        <div class='padding5'>

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
          <div class="card">
            <div class="item item-divider">
              Order Number
            </div>
            <div id="orderid" class="item item-text-wrap">
            </div>
          </div>
          <div class="card">
            <div class="item item-divider">
              Paid <span>&#10004;</span>
            </div>
          </div>

          <div id='completediv'>
            <button class='button button-block button-dark' id='email'>Email this screen</button>
            <button class='button button-block button-dark' id='done' onclick="UI.views.init('SplashView')">Done</button>
          </div>

        </div>
      </div>
    """
