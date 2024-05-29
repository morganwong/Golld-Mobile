class RedeemOrderCompleteGolldView extends BaseView
  constructor: ()->
    super("RedeemOrderCompleteGolldView")

    @template = @tmpl
    @evtHandler = new RedeemOrderCompleteEvtHandler(@)
    @evtHandler.net.bindEvtToLink "getorder", NetEvtLinks.rest.OrderController.getorder

  init: (data) =>
    @injectUI({mobileBackBtn : ->
      trace ""
    })
    @olddata = JSON.parse(AppProps.get("accdata"))
    @order = AppProps.get "order"
    trace "got order..."
    trace @order
    @order = JSON.parse @order
    trace @order

    @evtHandler.net.urlParams({
      oid : @order.order.id
    }).get "getorder"


  filldetails : (data) =>
    trace data
    $('#voucher').html data.whichcurrency
    $('#amount').html data.amountordered
    $('#ethereumaddress').html data.ethaddress
    $('#orderid').html data.ordernumber
    switch data.paymenttype
      when "stripe"
        $('#paymentmethod').html "Credit / Debit card"
      when "userfunds"
        $('#paymentmethod').html "User Funds"
        $('#currency').html @olddata.currency
        $('#currencycontainer').show()
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
            <button class='button button-large button-dark' id='email'>Email this screen</button>
            <button class='button button-large button-dark' id='done' onclick="UI.views.init('AccountGolldView')">Done</button>
          </div>

        </div>
      </div>
    """
