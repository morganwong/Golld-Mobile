class MyAccountGolldView extends BaseView
  constructor: ()->
    super("MyAccountGolldView")

    @template = @tmpl
    @evtHandler = new MyAccountGolldEvtHandler(@)

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

    data = JSON.parse(AppProps.get("accdata"))


    for c of data.funds
      $('#' + [c]).text  [c] + ': ' + data.funds[c]
      trace [c]
    for i of data
      text = $('#'+[i]+'field').text()
      if data[i] is null
        $('#'+[i]+'field').text(text + 'Define in account details')
      else
        $('#'+[i]+'field').text(text + data[i])

    @checkapproved(data)
    @checkuploaded(data)
    @checkcomplete(data)

  checkuploaded:(data) ->
    if data.kycUploaded.NONPHOTOID is true and data.kycUploaded.PHOTOID is true
      $('#uploaded').text('Uploaded: All documents uploaded.')
      $('#uploaded').css('color','green')
    else
      $('#uploaded').text('Uploaded: Not uploaded.')
      $('#uploaded').css('color','red')
  checkapproved:(data) ->
    if data.kycApproved.NONPHOTOID is true and data.kycApproved.PHOTOID is true
      $('#approved').text('Approved: All documents approved.')
      $('#approved').css('color','green')
    else
      $('#approved').text('Approved: Not approved.')
      $('#approved').css('color','red')
  checkcomplete:(data) ->
    if data.allKycApproved is true
      $('#complete').text('Complete: All documents complete.')
      $('#complete').css('color','green')
    else
      $('#complete').text('Complete: Not complete.')
      $('#complete').css('color','red')

  tmpl: (data) ->
    """
      <div class='bar bar-header bar-light'>
        <back class='button'>Back</back>
        <h1 class='title'>My Account</h1>
        <logout class='button'>Logout</logout>
      </div>
    <div class='content2 content'>
      <div class='item item-divider'>
       Funds Available
      </div>
      <div class='list-inset'>
        <div class='item'  style='text-align: center'>
        <p  id='USD'>USD: 0 </p>
        <p  id='EUR'>EUR: 0 </p>
        <p  id='CNY'>CNY: 0 </p>
        <p  id='GBP'>GBP: 0 </p>
        <p  id='JPY'>JPY: 0 </p>
        </div><br>
      </div>
      <div class='item item-divider'>
       Status of your documents
      </div>
      <div class='list-inset'>
        <p class='item' id='complete'>Placeholder</p>
        <p class='item' id='uploaded'>Placeholder</p>
        <p class='item' id='approved'>Placeholder</p><br>
      </div>
      <div class='item item-divider'>
       Account Information
      </div>
      <div class='list-inset'>
      <p class='item' id='firstNamefield'>First Name: </p>
      <p class='item' id='lastNamefield'>Last Name: </p>
      <p class='item' id='emailfield'>Email: </p>
      <p class='item' id='phonefield'>Phone: </p>
      <p class='item' id='usernamefield'>Username: </p><br>
      </div>
     </div>
    """