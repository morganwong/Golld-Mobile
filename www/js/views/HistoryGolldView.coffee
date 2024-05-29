class HistoryGolldView extends BaseView
  constructor: ()->
    super("HistoryGolldView")

    @template = @tmpl
    @evtHandler = new HistoryGolldEvtHandler(@)

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "AccountGolldView"})
    $('back').click ->
      UI.views.init('AccountGolldView')
    $('logout').click ->
      AppProps.logout()
      if AppProps.uid is null
        UI.views.init('SplashView')
      else
        return




    getorders= JSON.parse(AppProps.get("getorders"))

    getfundorders= JSON.parse(AppProps.get("getfundorders"))

    trace ' IN VIEW '
    trace getorders
    trace getfundorders

    for i of getfundorders
      if getfundorders[i].fundStatus is "COMPLETED"
        $('.list1').append("<div class=\'row\'>
                <div class=\'col item\'>"+getfundorders[i].amount+"</div>
                <div class=\'col item\'>"+getfundorders[i].currency+"</div>
                <div class=\'col item\'>"+getfundorders[i].fundMethod+"</div>
                <div class=\'col item\'>"+getfundorders[i].fundStatus+"</div>
              </div>")

      else
        trace ' not completed '

    for i of getorders
      if getorders[i].paymentStatus is "COMPLETED"
        trace getorders[i]
        trace [i]
        trace ' NUMBER '
        $('.list2').append("<div class=\'row\'>
                 <div class=\'col item\'>"+getorders[i].amountOrdered+"</div>
                 <div class=\'col item\'>"+getorders[i].amountPaid+"</div>
                 <div class=\'col item\'>"+getorders[i].orderCurrency+"</div>
                 <div class=\'col item\'>"+getorders[i].paymentType+"</div>
                 <div class=\'col item\'>"+getorders[i].whichCurrency+"</div>
               </div>")

      else
        trace ' not completed '

  tmpl: (data) ->
    """
        <div class='bar bar-header bar-light'>
          <back class='button'>Back</back>
          <h1 class='title'>History</h1>
          <logout class='button'>Logout</logout>
        </div>
      <div class='content2 content'>
            <div class='list list1'>
              <label for='mainrow' class='title item item-divider'><h3 style='font-family: italic;'>Funds</h3></label>
              <div id=' mainrow' class='row' >
                <div style='font-family:italic;' class='col item item-divider'>Amount</div>
                <div style='font-family:italic;' class='col item item-divider'>Currency</div>
                <div style='font-family:italic;' class='col item item-divider'>Payment Method</div>
                <div style='font-family:italic;' class='col item item-divider'>Status</div>
              </div>
            </div>
            <div class='list list2'>
              <label for='mainrow1' class='title item item-divider'><h3 style='font-family: italic;'>Orders</h3></label>
              <div id=' mainrow1' class='row' >
                <div style='font-family:italic;' class='col item item-divider'>Ordered</div>
                <div style='font-family:italic;' class='col item item-divider'>Paid</div>
                <div style='font-family:italic;' class='col item item-divider'>Currency Used</div>
                <div style='font-family:italic;' class='col item item-divider'>Payment Method</div>
                <div style='font-family:italic;' class='col item item-divider'>Token</div>
              </div>
            </div>
       </div>
      """