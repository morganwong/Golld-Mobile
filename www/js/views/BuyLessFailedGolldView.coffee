class BuyLessFailedGolldView extends BaseView
  constructor: ()->
    super("BuyLessFailedGolldView")

    @template = @tmpl
    @evtHandler = new BuyLessFailedEvtHandler(@)
    @evtHandler.net.bindEvtToLink "getfailedorder", NetEvtLinks.rest.OrderController.getorder

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
    }).get "getfailedorder"


  filldetails : (data) =>
    trace data
    $('#voucher').html data.whichcurrency
    $('#amount').html data.amountordered
    $('#ethereumaddress').html data.ethaddress
    $('#orderid').html data.ordernumber
    $('#failed').html data.failedmessage
    switch data.paymenttype
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
              Failed <span>&#10008;</span>
            </div>
            <div id="failed" class="item item-text-wrap">
            </div>
          </div>

          <div id='completediv'>
            <button class='button button-large button-dark' id='email'>Email this screen</button>
            <button class='button button-large button-dark' id='tryagain' onclick="UI.views.init('BuyLessGolldView')">Try Again</button>
            <button class='button button-large button-dark' id='done' onclick="UI.views.init('SplashView')">Done</button>
          </div>

        </div>
      </div>
    """
