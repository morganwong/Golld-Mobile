class BuyLessBuyGolldView extends BaseView
  constructor: ()->
    super("BuyLessBuyGolldView")

    @template = @tmpl
    @evtHandler = new BuyLessBuyEvtHandler(@)
    @evtHandler.net.bindEvtToLink "makebuylessorder", NetEvtLinks.rest.OrderController.makebuylessorderstripe

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "BuyLessGolldView"})

    @oid = AppProps.get "orderid"
    @tid = AppProps.get "paymenttoken"
    trace "oid is " + @oid
    trace "tid is " + @tid
    
    order = AppProps.get "order"
    trace "order incoming..."
    trace order
    order = JSON.parse order
    trace order

    $('#voucher').html order.voucher.toUpperCase()
    $('#amount').html order.amount
    $('#ethereumaddress').html order.address
    switch order.paymentmethod
      when "stripe"
        $('#paymentmethod').html "Credit / Debit card"
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

    $('#cancelpaymentbutton').click ->
      AppProps.store "orderid", null
      AppProps.store "paymenttoken", null
      AppProps.store "order", null
      window.plugins.toast.showShortCenter("Transaction Cancelled!")
      UI.views.init "SplashView"

#    $('button').click ->
#      handler.open({
#        name: "Golld",
#        description: "Payment",
#        amount: order.amount * 100
#      })
#
#    window.addEventListener("popstate", () ->
#      handler.close()
#    )
#
#    handler = StripeCheckout.configure({
#      key: 'pk_test_6pRNASCoBOKtIshFeQd4XMUh',
#      image: 'https://gollddotcom.herokuapp.com/img/CoinGollldLogo150px.png',
#      locale: 'auto',
#      allowRememberMe: false,
#      currency: "EUR",
#      email: "N/A",
#      token: (token) =>
#        trace "In TOKEN function !! token incoming..."
#        trace token
#        trace token.id
#
#        $('button').prop("disabled", "true")
#        @evtHandler.net.urlParams({
#          orderid : @oid
#          st : token.id
#          token : @tid
#        }).post "makebuylessorder"
#    })

    # Create a Stripe client.
    stripe = Stripe('pk_test_6pRNASCoBOKtIshFeQd4XMUh')

    # Create an instance of Elements.
    elements = stripe.elements()

    # Custom styling can be passed to options when creating an Element.
    # (Note that this demo uses a wider set of styles than the guide below.)
    style = {
      base: {
        color: '#32325d',
        lineHeight: '18px',
        fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
        fontSmoothing: 'antialiased',
        fontSize: '16px','::placeholder': {
          color: '#aab7c4'
        }
      },
      invalid: {
        color: '#fa755a',
        iconColor: '#fa755a'
      }
    }

    # Create an instance of the card Element.
    card = elements.create('card', {style: style})

    # Add an instance of the card Element into the `card-element` <div>.
    card.mount('#card-element')

    # Handle real-time validation errors from the card Element.
    card.addEventListener('change', (event) =>
      displayError = document.getElementById('card-errors')
      if event.error
        displayError.textContent = event.error.message
      else
        displayError.textContent = ''
    )

    # Handle form submission.
    form = document.getElementById('payment-form');
#    form.addEventListener('submit', (event) =>
    $('#payment-form').submit (event) =>
      event.preventDefault()
      stripe.createToken(card).then( (result) =>
        if result.error
        # Inform the user if there was an error.
          errorElement = document.getElementById('card-errors')
          errorElement.textContent = result.error.message;
        else
        # Send the token to your server.
          trace "result incoming..."
          trace result
          trace JSON.stringify result
          trace "Stripe token incoming..."
          trace result.token
          trace JSON.stringify result.token
          trace "actual Stripe token incoming..."
          trace result.token.id
#          stripeToken = result.token.id
          $('button').prop("disabled", "true")
          @evtHandler.net.urlParams({
            orderid : @oid
            st : result.token.id
            token : @tid
          }).post "makebuylessorder"

          ###
  result = {
	"token":{
		"id":"tok_1DZFbr2eZvKYlo2ChvJ9uMII",
		"object":"token",
		"card":{
			"id":"card_1DZFbr2eZvKYlo2CQ727822m",
			"object":"card",
			"address_city":null,
			"address_country":null,
			"address_line1":null,
			"address_line1_check":null,
			"address_line2":null,
			"address_state":null,
			"address_zip":"66666",
			"address_zip_check":"unchecked",
			"brand":"Visa",
			"country":"US",
			"cvc_check":"unchecked",
			"dynamic_last4":null,
			"exp_month":12,
			"exp_year":2019,
			"funding":"credit",
			"last4":"4242",
			"metadata":{},
			"name":null,
			"tokenization_method":null
		},
		"client_ip":"46.7.157.216",
		"created":1542883235,
		"livemode":false,
		"type":"card",
		"used":false
	}
}
          ###
      )




  tmpl: (data) ->
    """
      <style>
        .StripeElement {
          background-color: white;
          height: 40px;
          padding: 10px 12px;
          border-radius: 4px;
          border: 1px solid transparent;
          box-shadow: 0 1px 3px 0 #e6ebf1;
          -webkit-transition: box-shadow 150ms ease;
          transition: box-shadow 150ms ease;
        }

        .StripeElement--focus {
          box-shadow: 0 1px 3px 0 #cfd7df;
        }

        .StripeElement--invalid {
          border-color: #fa755a;
        }

        .StripeElement--webkit-autofill {
          background-color: #fefde5 !important;
        }
      </style>

      <div class="has-header">
        <div class='padding5'>

          <h3>Confirm Order:</h3>
          <h4>Make sure you have supplied the correct Ethereum address!</h4>

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

          <!-- <button class='button button-large button-dark' style='margin-top: 30px'>Buy</button> -->


          

          <form action="/charge" method="post" id="payment-form">
            <div class="form-row">
              <label for="card-element">
                Credit or debit card
              </label>
              <br>
              <div id="card-element">
                <!-- A Stripe Element will be inserted here. -->
              </div>

              <!-- Used to display form errors. -->
              <div id="card-errors" role="alert"></div>
            </div>
            <br>

            <button class='button button-block button-dark'>Submit Payment</button>
            <button class='button button-block' id="cancelpaymentbutton">Cancel</button>
          </form>



        </div>
      </div>
    """
