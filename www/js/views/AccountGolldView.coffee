class AccountGolldView extends BaseView
  constructor: ()->
    super("AccountGolldView")

    @template = @tmpl
    @evtHandler = new AccountGolldEvtHandler(@)
    @evtHandler.net.bindEvtToLink "getaccount", NetEvtLinks.rest.AccountController.getaccount
    @evtHandler.net.bindEvtToLink 'getorders', NetEvtLinks.rest.AccountController.getorders
    @evtHandler.net.bindEvtToLink 'getfundorders', NetEvtLinks.rest.AccountController.getfundorders
  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "SplashView"})

    @evtHandler.net.urlParams({
      id : AppProps.get "uid"
    }).get "getaccount"
    @evtHandler.net.urlParams({
      id : AppProps.get "uid"
    }).get "getorders"
#    @evtHandler.net.urlParams({
#      uid : AppProps.uid
#    }).get "getfundorders"

    $('logout').click ->
      AppProps.logout()
      UI.views.init('SplashView')



  tmpl: (data) =>
    """
      <div class="bar bar-header bar-light">
      <h1 class='title'>Account view</h1>
      </div>

      <div class='content2'>
      <div class='padding5'><img src='img/CoinGollldLogo150px.png'/></div>
      <button class="button button-block button-positive button-dark" onclick="UI.views.init('MyAccountGolldView')">
        My Account
      </button>
      <button class="button button-block button-positive button-dark" onclick="UI.views.init('FundGolldView')">
        Fund
      </button>
      <button class="button button-block button-positive button-dark" onclick="UI.views.init('HistoryGolldView')">
        History
      </button>
      <button class="button button-block button-positive button-dark" onclick="UI.views.init('RedeemGolldView')">
        Redeem
      </button>
      <button class="button button-block button-positive button-dark" onclick="UI.views.init('AccountDetailsGolldView')">
        Account Details
      </button>
      <button class="button button-block button-positive button-dark" onclick="UI.views.init('KYCGolldView')">
        KYC
      </button>
      <logout class="button button-block button-positive button-stable">
        Logout
      </logout>
      </div>

    """
