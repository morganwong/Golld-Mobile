class RedeemOrderWaitingGolldView extends BaseView
  constructor: ()->
    super("RedeemOrderWaitingGolldView")

    @template = @tmpl
    @evtHandler = new RedeemOrderWaitingEvtHandler(@)
    @evtHandler.net.bindEvtToLink "poll", NetEvtLinks.rest.OrderController.pollfororder

  init: (data) =>
    @injectUI({mobileBackBtn : ->
      alert "Can't go back right now, waiting on order confirmation!"
    })
    data = JSON.parse(AppProps.get("accdata"))
    @order = AppProps.get "order"
    trace "got order..."
    trace @order
    @order = JSON.parse @order
    trace @order

    $('#voucher').html @order.order.whichcurrency
    $('#amount').html "Amount Ordered: " + @order.order.amountordered
    $('#ethereumaddress').html @order.order.ethaddress
    switch @order.order.paymenttype
      when "stripe"
        $('#paymentmethod').html "Credit / Debit card"
      when "userfunds"
        $('#paymentmethod').html "User Funds"
        $('#currency').html data.currency
        $('#currencycontainer').show()
      when "banktransfer"
        trace ""
      when "cryptocurrency"
        trace ""
      else
        trace "ERROR in switch..."

    @poll()

  poll : () =>
    trace "polling..."
    @evtHandler.net.urlParams({
      orderid : @order.order.id
    }).get "poll"

  tmpl: (data) ->
    """
      <div class="has-header">
        <div class='padding5'>
          <div id='currencycontainer' class="card" style='display:none;'>
            <div class="item item-divider">
              Currency used to pay
            </div>
            <div id="currency" class="item item-text-wrap">
            </div>
          </div>
          <div class="card">
            <div id="voucher" class="item item-text-wrap">
            </div>
          </div>
          <div class="card">
            <div id="amount" class="item item-text-wrap">
            </div>
          </div>
          <div class="card">
            <div id="paymentmethod" class="item item-text-wrap">
            </div>
          </div>
          <div class="card">
            <div id="ethereumaddress" class="item item-text-wrap">
            </div>
          </div>

          <div id='processingdiv'>
            <img src='img/loading.svg'/>
            <h3>Processing order... please wait</h3>
          </div>

        </div>
      </div>
    """