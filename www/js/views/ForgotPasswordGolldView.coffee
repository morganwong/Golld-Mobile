class ForgotPasswordGolldView extends BaseView
  constructor: ()->
    super("ForgotPasswordGolldView")

    @template = @tmpl

  init: (data) =>
    @injectUI({mobileBackBtn : -> UI.views.init "AdminView"})

    ctx = @
    $('golldtab').click ->
      if $(this).text() is "Golld"
        trace ""
        ctx.doActive('golldtab', $(this).text(), ctx)
        UI.views.init "SplashView"
      else
        $(this).css "opacity", 0.2
        if window.plugins?
          window.plugins.toast.showShortCenter("!")
        else
          trace "!"


    $('span').click ->
      sid = $(this).attr("id")
      $('#helpoverlay').find('p').each(() ->
        if $(this).attr("id") is sid + "text"
          $(this).show()
        else
          $(this).hide()
      )
      $('#helpoverlay').slideDown()

    $('#helpoverlay').click ->
      $('#helpoverlay').slideUp()


  doActive : (tag, text, ctx) ->
    $('body').find(tag).each(->
      if $(this).text() is text
        $(this).html "<strong>" + $(this).text() + "</strong>"
      else
        $(this).html ctx.removeBold($(this).text())
    )

  removeBold : (str) ->
    if str.indexOf "<strong>" is -1
      return str
    else
      str = str.replaceAll "<strong>", ""
      str = str.replaceAll "</strong>", ""

  tmpl: (data) ->
    """
      <div id='splash'>
          PLACEHOLDER
      </div>

      <
      <div id='footer' class='tabs'>
          <golldtab class='tab-item'>Golld</golldtab>
          <golldtab class='tab-item'>Wallet</golldtab>
      </div>
    """
