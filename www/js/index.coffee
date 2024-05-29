deviceReady = ->
  trace 'we are ready'
  new SplashView()
  new AdminView()
  new AnonymousCreateView()
  new WalletView()
  new VerifiedCreateView()

  new AccountGolldView()
  new MyAccountGolldView()
  new FundGolldView()
  new RedeemGolldView()
  new HistoryGolldView()
  new AccountDetailsGolldView()
  new KYCGolldView()
  new BuyLessBuyGolldView()
  new BuyLessWaitingGolldView()
  new BuyLessCompleteGolldView()
  new BuyLessFailedGolldView()
  new FundLessFundView()
  new FundLessView()
#  new WalletSplashView()
  new FundMoreView()
  new FundMoreFundView()
  new RedeemOrderGolldView()
  new RedeemOrderWaitingGolldView()
  new RedeemOrderCompleteGolldView()
#  new LoginCreateGolldView()
  new LoginView()
  new RedeemOrderFailedGolldView()
  new AddTokenWalletView()
  new SendTokenWalletView()
  new SendTokenConfirmWalletView()
  new ForgotPasswordGolldView()
  new GetPaidView()
  new PayView()
  new GolldPayView()

  new BuyLessGolldView()

  window.alert = (msg, title = 'Alert', ok = 'OK') ->
    if navigator?.notification?
      navigator.notification.alert(
        msg,
        null,
        title,
        ok
      )
    else
      trace 'ALERT!!!!!!!!! ' + msg

  UI.views.init("SplashView")

$(document).ready ->
  $(document).bind("deviceready", deviceReady)
