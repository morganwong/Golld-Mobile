class FundGolldView extends BaseView
  constructor: ()->
    super("FundGolldView")

    @template = @tmpl
    @evtHandler = new FundGolldEvtHandler(@)

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "AccountGolldView"})
    @evtHandler.handleEvt("getaccount", AppProps.accdata)
    data = JSON.parse(AppProps.get("accdata"))
    $('#currency').text data.currency

    $('back').click ->
      UI.views.init('AccountGolldView')
    $('logout').click ->
      AppProps.logout()
      if AppProps.uid is null
        UI.views.init('SplashView')
      else
        return
    if data.AllKycApproved is true
        $('#morethan').attr('disabled','false')
    else
      $('#morethan').attr('disabled','true')



    if data.allKycApproved is true
      $('#fundcomplete').text('You can buy more than 10,000!')
      $('#fundcomplete').css('color','green')
    else
      $('#fundcomplete').text('Your documents must be approved and uploaded to buy more than 10,000!')
      $('#fundcomplete').css('color','red')
    $('#morethan').click ->
      UI.views.init('FundMoreView')
    $('#lessthan').click ->
      UI.views.init('FundLessView')
  tmpl: (data) ->
    """
      <div class="bar bar-header bar-light">
        <back class='button'>Back</back>
        <h1 class='title'>Fund Your Account</h1>
        <logout class='button'>Logout</logout>
      </div>

      <div class='content2 content'>
         <div>
          <p id='fundcomplete'></p>
          <p>Your currently selected default currency:</p><p id='currency'></p>
         </div>
          <button id='morethan' class='button' disabled>Fund more than 10,000</button>
          <button id='lessthan' class='button'>Fund less than 10,000</button>
      </div>

    """
