class FundMoreEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in fund more evt handler"

    if name is "fundaccount"
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
        AppProps.store "fundneworder", data
        UI.views.init "FundMoreFundView"
        trace " "
      else
        alert data.substring(8)
        $('button').prop("disabled", false)

    if name is 'error'
      trace "error : " + data
      trace data