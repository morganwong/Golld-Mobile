class RedeemGolldEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in redeem golld evt handler"

    if name is "accountorder"
      trace data
      if data.indexOf("ERROR - ") is -1
        trace "success"
        #        {
        #          "gvs_token":"p2CPkbRb7hjrP2DQlrvkrzAibKUZ2SS_T2cYQXaYaCvtnuUWyOrTwg~~",
        #          "order":{
        #            "acc":"null",
        #            "amountordered":"175",
        #            "created":"1527698153805",
        #            "ethaddress":"agajdkfjsbfkshakfhdjshakfhdjdjshdkfjdjdj",
        #            "paid":"0",
        #            "paymentstatus":"created",
        #            "amountpaid":"null",
        #            "id":"NbopSxPbMbXYjg9YkfJArRKiZWdz6NG_wA-oOXzt1TcCKz0Oav90UA~~",
        #            "paymenttype":"stripe",
        #            "whichcurrency":"EUROGOLLD"
        #          }
        #        }
        AppProps.store "order", data
        UI.views.init "RedeemOrderGolldView"
      else
        alert data.substring(8)
        $('button').prop("disabled", false)

    if name is 'error'
      trace "error : " + data
      trace data