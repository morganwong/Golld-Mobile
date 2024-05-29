class FundLessFundView extends BaseView
  constructor: ()->
    super("FundLessFundView")

    @template = @tmpl
    @evtHandler = new FundLessFundEvtHandler(@)
    @evtHandler.net.bindEvtToLink "fundaccountstripe", NetEvtLinks.rest.AccountController.fundaccountstripe

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "FundLessView"})

    order = AppProps.get "fundorder"
    neworder = AppProps.get "fundneworder"
    trace "order incoming..."
    trace order
    order = JSON.parse order
    neworder = JSON.parse neworder
    trace order
    trace neworder
    data = JSON.parse(AppProps.get("accdata"))

    $('#Currency').text data.currency

    $('#amount').text order.amount

    switch order.paymentmethod
      when "stripe"
        $('#paymentmethod').html "Credit / Debit card"
      when "banktransfer"
        trace ""
      when "cryptocurrency"
        trace ""
      else
        trace "ERROR in switch..."

    $('button').click ->
      handler.open({
        name: "Golld",
        description: "Payment",
        amount: order.amount * 100
      })

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
          amount : order.amount
          currency : data.currency
          orderid : neworder.fundorderid
          st : token.id
          token : neworder.gvs_token
        }).post "fundaccountstripe"
    })

  tmpl: (data) ->
    """
      <div class="has-header">
        <div class='padding5'>

          <h3>Confirm Order:</h3>
          <h4>Make sure you the data below is correct!</h4>

          <div class="card">
            <div class="item item-divider">
              Currency
            </div>
            <div id="Currency" class="item item-text-wrap">
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


          <button class='button button-large button-dark' style='margin-top: 30px'>Buy</button>

        </div>
      </div>
    """
