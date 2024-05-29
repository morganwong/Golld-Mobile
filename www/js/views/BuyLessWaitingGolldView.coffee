class BuyLessWaitingGolldView extends BaseView
  constructor: ()->
    super("BuyLessWaitingGolldView")

    @template = @tmpl
    @evtHandler = new BuyLessWaitingEvtHandler(@)
    @evtHandler.net.bindEvtToLink "poll", NetEvtLinks.rest.OrderController.pollfororder

  init: (data) =>
    @injectUI({mobileBackBtn : ->
      alert "Can't go back right now, waiting on order confirmation!"
    })

    @order = AppProps.get "order"
    trace "got order..."
    trace @order
    @order = JSON.parse @order
    trace @order

    @oid = AppProps.get "orderid"
    
    $('#voucher').html @order.voucher.toUpperCase()
    $('#amount').html "Amount Ordered: " + @order.amount
    $('#ethereumaddress').html @order.address
    switch @order.paymentmethod
      when "stripe"
        $('#paymentmethod').html "Credit / Debit card"
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
      orderid : @oid
    }).get "poll"

  tmpl: (data) ->
    """
      <div class="has-header">
        <div class='padding5'>

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
