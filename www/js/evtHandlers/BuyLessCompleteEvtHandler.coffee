class BuyLessCompleteEvtHandler extends BaseEvtHandler
  constructor: (@view)->
    super @view

  handleEvt: (name, data) =>

    trace "in buy less complete evt handler"
    
    if name is "getorder"
      trace data
      ###
      {"id":"iqnvGNJg36t4LoXYXARgPhKK9bHt11lOg9Vu5c1xbkZuUWsdzLLoEw~~",
      "paymentType":"STRIPE","amountOrdered":"10","amountPaid":"10",
      "ethAddress":"0x5bc26c7a1da49878b7398617485834091dbe7da5","paymentStatus":"COMPLETED",
      "failedMessage":null,"created":1542903211118,"paid":1542903228163,"orderNumber":"6",
      "orderCurrency":"EUR","whichCurrency":"EUROGOLLD"}
      ###
      @view.filldetails(JSON.parse data)

    if name is 'error'
      trace "error : " + data
      trace data