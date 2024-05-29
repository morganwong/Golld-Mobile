traceObj = (o) -> trace k + ' : ' + v for k, v of o

class BaseView

  @phoneBound : false

  @contentID = "#id_mainContent"

  @bindPhoneBackButton : (cb) ->
    if cb?
      $(document).unbind("backbutton")
      $(document).bind("backbutton", -> cb())
      return trace 'custom back from phone button is set up...'

    $(document).unbind("backbutton")
    $(document).bind("backbutton", ->
      trace 'attempting back from phone button...'
      UI.views.init('home')
      # add state mgr
#      ViewsManager.homePage.init()
    )

    trace 'back from phone button is set up...'

  template: () ->

  constructor: (@name) ->
    UI.views.addView(@name, @)

    trace "ctord #{@name}"

    @defaultOpts = {
      bindBack : true
      cache : false
      classes : [ "app" ]
      consoleClear : false
      mobileBackBtn : null
    }

  injectUI: (opts) =>
    $('html, body').animate({ scrollTop: 0 }, 0)

    if not opts? then opts = {}

    opts = $.extend(@defaultOpts, opts)

    traceObj opts
    traceObj @defaultOpts

    if @defaultOpts.consoleClear and console.clear? then console.clear()

    BaseView.bindPhoneBackButton(opts.mobileBackBtn)

    tmpl = @template()

    $(BaseView.contentID).html @template()

    if opts.bindBack then @bindBack()

    $(BaseView.contentID).removeClass()
    $(BaseView.contentID).addClass(c) for c in opts.classes

    trace "base injectUI done..."

  bindBack : ->
    trace 'binding back link'
    $('[data-back]').each ->
      $(@).click ->
        target = $(@).attr 'data-back'
        trace 'bac to....' + target
        trace 'completed'

    trace 'back links bound...'

  bindInputChange : ->
    $("input[type='text'], input[type='number'], input[type='password']").change -> ViewsManager.hideKeyboard()

  validate : ->
    # text
    $("input[type='text'],input[type='password'],input[type='number'],input[type='datetime'],input[type='email'],input[type='date']").each ->
      if not $(@).attr('data-validateOff')?
        v = $(@).val()
        if v.length is 0
          if $(@).attr 'data-vld-msg'
            alert $(@).attr 'data-vld-msg'
            return false

    # number
    $("input[type='number']").each ->
      if not $(@).attr('data-validateOff')?
        v = parseInt($(@).val())

        min = $(@).attr 'min'
        max = $(@).attr 'max'

        if v < min
          if $(@).attr 'data-vld-msg-min'
            alert $(@).attr 'data-vld-msg-min'
            return false

        if v > max
          if $(@).attr 'data-vld-msg-max'
            alert $(@).attr 'data-vld-msg-max'
            return false

    true

#custom pop up functions below

#   *******N.B*******
# These aren't as seamless as the js provided versions. Each has 3 functions which must be used correctly to retain intended functionality:
#         -1st function is used at the top of the view to add the popup functionality to the view; starts hidden
#         -2nd function is to call the popup when required, passing the text to be displayed in as an arg
#         -3rd function is to clear the popup, allowing for reuse within the view where required

# In the case of the Alert and Confirm popup, listeners must be provided within the view to handle the associated button clicks (i.e 'OK' in AlertPopup and 'Confirm/Cancel' in ConfirmPopup
# Example currently in the WelcomeView that makes use of both together

  customAlertPopup : () -> #To invoke the customAlert in the view
    $(BaseView.contentID).prepend """
      <div class='cl_hidden' id='modal_alert'>
        <div class='alert_modal cl_hidden' id='alert_modal'>
          <div style='min-height: 60%'>
            <p id='customAlert_text' style='font-size: medium'></p>
          </div>
          <div style='margin-bottom: 5% !important'>
            <div style='margin-left: 10% !important; margin-right: 15% !important; width: 60%' class='popupBtn cl_hidden' id='alert_close_btn'>OK</div>
          </div>
        </div>
      </div>
    """

  callAlertPopup : (msg) ->
    $('#modal_alert').addClass('overlay')
    $('#modal_alert').removeClass('cl_hidden')
    $('#modal_alert').css({'z-index' : '998'})
    $('#alert_modal').css({'z-index' : '999'})
    $('#alert_modal').removeClass('cl_hidden')
    $('#alert_close_btn').removeClass('cl_hidden')
    $('html, body').animate({ scrollTop: "0px" }, "fast");
    $('#customAlert_text').prepend msg
    trace "customAlert!!"+msg

  dismissAlertPopup : () ->
    $('#modal_alert').removeClass('overlay')
    $('#modal_alert').addClass('cl_hidden')
    $('#modal_alert').css({'z-index' : '-1'})
    $('#alert_modal').css({'z-index' : '-1'})
    $('#alert_modal').addClass('cl_hidden')
    $('#alert_close_btn').addClass('cl_hidden')
    $('#customAlert_text').text ""

  customConfirmPopup : () -> #To provide information along with 'Confirm' and 'Cancel' buttons. Provide statement to be authorized (msg)
    $(BaseView.contentID).prepend """
       <div id='confirm_modal' class='confirm_modal cl_hidden'>
        <p id='customConfirm_text' style='font-size: medium; font-weight: bold;'></p>
        <button id='modal_confirm_btn' class='button button-block popupBtn cl_hidden'>Confirm</button>
        <button id='modal_cancel_btn' class='button button-block popupBtn cl_hidden'>Cancel</button>
      </div>
    """

  callConfirmPopup : (msg) ->
    $('#confirm_modal').css({'z-index' : '999'})
    $('#confirm_modal').removeClass('cl_hidden')
    $('#modal_confirm_btn').removeClass('cl_hidden')
    $('#modal_cancel_btn').removeClass('cl_hidden')
    $('#customConfirm_text').prepend msg

  dismissConfirmPopup: () =>
    $('#confirm_modal').addClass('cl_hidden')
    $('#confirm_modal').css({'z-index' : '-1'})
    $('#modal_confirm_btn').addClass('cl_hidden')
    $('#modal_cancel_btn').addClass('cl_hidden')
    $('#customConfirm_text').text ""

  customWorkingPopup : (msg) -> #To provide information notifying a user of an ongoing action requiring them to wait. Provide waiting message (msg)
    $(BaseView.contentID).prepend """
      <div class='cl_hidden' id='modal_working'>
        <div class='alert_modal cl_hidden' id='working_modal'>
          <p id='customWorking_text' style='font-size: medium; font-weight: bold; '>
          <img src='img/loading.svg' style='position: absolute; margin: auto; left: 0; top: 0; right: 0; bottom: 0; z-index: 250;'>
          </p>
        </div>
      </div>
    """
    $('#customWorking_text').prepend msg

  callWorkingPopup : () -> #To call the above customWorkingPopup. Call in event where you wish to trigger the popup. N.B Must be paired with the dismiss function below to use correctly...
    $('#modal_working').addClass('overlay')
    $('#working_modal').removeClass('cl_hidden')
    $('#modal_working').removeClass('cl_hidden')
    $('#modal_working').css({'z-index' : '999'})
    $('#working_modal').css({'z-index' : '999'})

  dismissWorkingPopup : () -> #To dismiss the above customWorkingPopup. Call in event where you wish to dismiss the popup. N.B Not using this will prevent any user action within the view!!
    $('#modal_working').removeClass('overlay')
    $('#working_modal').removeClass('modal-content')
    $('#working_modal').addClass('cl_hidden')
    $('#modal_working').addClass('cl_hidden')
    $('#modal_working').css({'z-index' : '-1'})
    $('#working_modal').css({'z-index' : '-1'})
    $('#customWorking_text').text ""

  setAppWideLanguage : (l) ->
    switch l
      when "EN" then lOpts.Lang = lOpts.Lang_EN
      when "ES" then lOpts.Lang = lOpts.Lang_ES
      when "DE" then lOpts.Lang = lOpts.Lang_DE

    AppUtils.putFile("LangPref", l)
      
    return
