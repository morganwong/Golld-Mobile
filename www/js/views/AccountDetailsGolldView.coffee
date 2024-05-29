class AccountDetailsGolldView extends BaseView
  constructor: ()->
    super("AccountDetailsGolldView")

    @template = @tmpl
    @evtHandler = new AccountDetailsGolldEvtHandler(@)
    @evtHandler.net.bindEvtToLink 'edit', NetEvtLinks.rest.AccountController.editaccount

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
    @evtHandler.handleEvt("getaccount", AppProps.accdata)
    data = JSON.parse(AppProps.get("accdata"))

    $('#currencyfield').text data.currency
    $('#firstnamefield').text data.firstName
    $('#lastnamefield').text data.lastName
    $('#emailfield').text data.email
    $('#unamefield').text data.username
    $('#phonefield').text data.phone

    $('#phone').on "input", (event) ->
      if isNaN($(this).val())
        $(this).val ""
        alert "You can only enter numbers in the 'Phone' field!"

    $('button').click ->
      $(this).parent().find('label').show()
      $(this).parent().find('p').hide()
      $(this).parent().find('submit').show()
      $(this).parent().find('cancel').show()
      $(this).hide()
    $('cancel').click ->
      $(this).parent().find('label').hide()
      $(this).parent().find('p').show()
      $(this).parent().find('button').show()
      $(this).parent().find('submit').hide()
      $(this).hide()

    ctx = @
    $('submit').click ->
      id = $(this).attr "id"
      key = id.substring 0, id.indexOf "Submit"
      value = $("#" + key).val()
      if $("#" + key).val().length is 0
        alert (key + "&nbsp;can't be empty.")
      else
        ctx.evtHandler.net.urlParams({
          uid : AppProps.uid
          key : key
          value : value
        }).post "edit"
        $(this).parent().find('label').hide()
        $(this).parent().find('p').show()
        $(this).parent().find('button').show()
        $(this).parent().find('cancel').hide()
        $(this).hide()
        $('#'+key+'field').text(value)

  tmpl: (data) ->
    """
      <div class='bar bar-header bar-light'>
        <back class='button'>Back</back>
        <h1 class='title'>Account Details</h1>
        <logout class='button'>Logout</logout>
      </div>
    <div class='content2 content'>
      <div  class='list-inset'>
       <div  class='item item-input-inset'>
         <p style='width:100%;'><b>Currency:&nbsp;&nbsp;</b></p>
         <p style='width:100%;' id='currencyfield'>Placeholder</p>&nbsp;&nbsp;&nbsp;
         <button class='button'>Edit</button>
         <label class="item-input item-select" style='display:none;width:80%;'>
          <div class="input-label"  style='margin-left:-5%'>
            <b>Currency:</b>
          </div>
          <select id='currency'>
           <option value='EUR'>EUR</option>
           <option value='USD'>USD</option>
           <option value='YEN'>YEN</option>
          </select>
         </label><br>
         <submit class='button button-small' style='display:none;' id='currencySubmit'>Submit</submit>
         <cancel class='button button-small' style='display:none;'>Cancel</cancel>
       </div>
       <div class='item item-input-inset'>
         <p style='width:100%;'><b>First Name:&nbsp;&nbsp;</b></p>
         <p style='width:100%;' id='firstnamefield'>Placeholder</p>&nbsp;&nbsp;&nbsp;
         <button class='button'>Edit</button>
         <label class="item-input-wrapper" style='display: none;'>
            <input type='text' id='firstname' placeholder="New Name">
         </label><br>
         <submit class='button' style='display:none;' id='firstnameSubmit'>Submit</submit>
         <cancel class='button' style='display:none;'>Cancel</cancel>
       </div>
       <div class='item item-input-inset'>
         <p style='width:100%;'><b>Last Name:&nbsp;&nbsp;</b></p>
         <p style='width:100%;' id='lastnamefield'>Placeholder</p>&nbsp;&nbsp;&nbsp;
         <button class='button'>Edit</button>
         <label class="item-input-wrapper" style='display: none;'>
            <input type='text' id='lastname' placeholder="New Last Name">
         </label><br>
         <submit class='button' style='display:none;' id='lastnameSubmit'>Submit</submit>
         <cancel class='button' style='display:none;'>Cancel</cancel>
       </div>
       <div class='item item-input-inset'>
         <p style='width:100%;'><b>Phone:&nbsp;&nbsp;</b></p>
         <p style='width:100%;' id='phonefield'>Placeholder</p>&nbsp;&nbsp;&nbsp;
         <button class='button'>Edit</button>
         <label class="item-input-wrapper" style='display: none;'>
            <input type='text' id='phone' placeholder="New Phone number">
         </label><br>
         <submit class='button' style='display:none;' id='phoneSubmit'>Submit</submit>
         <cancel class='button' style='display:none;'>Cancel</cancel>
       </div>
       <div class='item item-input-inset'>
         <p style='width:100%;'><b>Username:&nbsp;&nbsp;</b></p>
         <p style='width:100%;' id='unamefield'>Placeholder</p>&nbsp;&nbsp;&nbsp;
         <button class='button'>Edit</button>
         <label class="item-input-wrapper" style='display: none;'>
            <input type='text' id='uname' placeholder="New UserName">
         </label><br>
         <submit class='button' style='display:none;' id='unameSubmit'>Submit</submit>
         <cancel class='button' style='display:none;'>Cancel</cancel>
       </div>
       <div class='item item-input-inset'>
         <p style='width:100%;'><b>Email:&nbsp;&nbsp;</b></p>
         <p style='width:100%;' id='emailfield'>Placeholder</p>&nbsp;&nbsp;&nbsp;
         <button class='button'>Edit</button>
         <label class="item-input-wrapper" style='display: none;'>
            <input type='text' id='email' placeholder="New Email">
         </label><br>
         <submit class='button' style='display:none;' id='emailSubmit'>Submit</submit>
         <cancel class='button' style='display:none;'>Cancel</cancel>
       </div><br>
      </div>
     </div>

    """