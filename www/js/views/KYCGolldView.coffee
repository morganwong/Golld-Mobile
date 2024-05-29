class KYCGolldView extends BaseView
  constructor: ()->
    super("KYCGolldView")

    @template = @tmpl
    @evtHandler = new KYCGolldEvtHandler(@)
    @evtHandler.net.bindEvtToLink 'uploadkycdocument', NetEvtLinks.rest.AccountController.uploadkycdocument
    @evtHandler.net.bindEvtToLink 'uploadkycdocumentimg', NetEvtLinks.rest.AccountController.uploadkycdocumentimg

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
    @filesuploaded(data)
#    @evtHandler.handleEvt("getaccount", data)

    @whichdoc = ""
    if data.accType is 'COMPANY'
      $('#Company').show()
      $('#USER').hide()
      console.log(data.accType.name)
    else
      $('#USER').show()
      $('#Company').hide()
    ctx = @

    $('cancel').click ->
      $(this).parent().find('submit').hide()
      $(this).parent().find('label').hide()
      $(this).parent().find('takepicture').show()
      $(this).parent().find('button').show()
      $(this).parent().find('cancel').hide()
      $(this).parent().find('label').html('Choose file')
    $('button').click ->
      $(this).parent().find('submit').show()
      $(this).parent().find('label').show()
      $(this).parent().find('label').css('display','block')
      $(this).hide()
      $(this).parent().find('takepicture').hide()
      $(this).parent().find('cancel').show()
#    @filesuploaded(data)

    $('takepicture').click ->
      navigator.camera.getPicture(ctx.cameraSuccess, ctx.cameraFail, {
        quality: 30,
        destinationType : Camera.DestinationType.DATA_URL,
        sourceType: Camera.PictureSourceType.CAMERA,
        correctOrientation :  true
      })
      ctx.whichdoc = $(this).parent().find('input').attr "id"
    $('input').on "input", (event) ->
      $(this).parent().find('label').html('Click submit &#9745;')
    files = []
    $('input').on "change", (event) ->
      files = event.target.files
      ctx.whichdoc = $(this).attr "id"



    $('submit').click ->
      trace "SUBMIT"
#      id = $(this).parent().find('input').attr "id"
      f = new FormData()
      f.append("file", files[0])
      $(this).parent().find('submit').hide()
      $(this).parent().find('input').hide()
      $(this).parent().find('takepicture').show()
      $(this).parent().find('button').show()
      $(this).parent().find('cancel').hide()
      $(this).parent().find('label').html('Choose file')
      $(this).parent().find('label').hide()
#      ctx.evtHandler.net..body({
#        f
#      }).urlParams({
#        uid : AppProps.uid,
#        whichdoc : whichdoc
#      }).post('uploadkycdocument')
      ctx.whichdoc = ctx.whichdoc.replace('Z','')
      trace 'in !!' + ctx.whichdoc
      $.ajax({
        dataType: 'text',
        url: NetEvtLinks.rest.AccountController.uploadkycdocument + "?uid=" + AppProps.get("uid") + "&whichdoc=" + ctx.whichdoc,
        data: f,
        type: 'POST',
        enctype: 'multipart/form-data',
        processData: false,
        contentType: false,
        success: (data) ->
          data = JSON.parse(AppProps.get("accdata"))
          alert "Success"
#          location.reload()
          trace data.accType
          if data.accType is "COMPANY"
            trace ctx.whichdoc
            trace " in " + ctx.whichdoc + " image "
            $('#'+ctx.whichdoc+'Img').attr('src', "#{AppProps.root}/accounts/getkycfile/" + data.username + "/" + ctx.whichdoc + '?timestamp=' + new Date().getTime())
          if data.accType is "INDIVIDUAL"
            trace " in " + ctx.whichdoc + " image "
            $('#'+ctx.whichdoc+'Image').attr('src', "#{AppProps.root}/accounts/getkycfile/" + data.username + "/" + ctx.whichdoc + '?timestamp=' + new Date().getTime())
        error: (data) ->
          alert "Error"
      })
#      if data.accType is "INDIVIDUAL"
#        $('#'+ctx.whichdoc+'Img').attr('src', "#{AppProps.root}/accounts/getkycfile/" + data.username + "/" + ctx.whichdoc + '?timestamp=' + new Date().getTime())
#      if data.accType is "INDIVIDUAL"
#        $('#'+ctx.whichdoc+'Image').attr('src', "#{AppProps.root}/accounts/getkycfile/" + data.username + "/" + ctx.whichdoc + '?timestamp=' + new Date().getTime())

  filesuploaded: (data) =>
    trace data
    trace data.kycUploaded.NONPHOTOID
    trace(data.kycUploaded.NONPHOTOID is true)

    for i of data.kycUploaded
      trace [i]
      trace data.accType
      whichdoc = [i]
      if data.accType is "COMPANY"
        if data.kycUploaded[i] is true
          $('#' + whichdoc + 'Upld').text('Uploaded')
          $('#' + whichdoc + 'Upld').css('color','green')
          $('#' + whichdoc + 'Img').attr('src', "#{AppProps.root}/accounts/getkycfile/" + data.username + "/" + whichdoc)
        else
          $('#' + whichdoc + 'Upld').text('Not Uploaded')
          $('#' + whichdoc + 'Upld').css('color','red')
      else if data.accType is "INDIVIDUAL"
        if data.kycUploaded[i] is true
          $('#' + whichdoc + 'Uploaded').text('Uploaded')
          $('#' + whichdoc + 'Uploaded').css('color','green')
          $('#' + whichdoc + 'Image').attr('src', "#{AppProps.root}/accounts/getkycfile/" + data.username+ "/" + whichdoc)
        else
          $('#' + whichdoc + 'Uploaded').text('Not Uploaded')
          $('#' + whichdoc + 'Uploaded').css('color','red')
      else
          alert("Account type is not defined!!!")


  cameraSuccess : (data) =>
    @whichdoc = @whichdoc.replace('Z','')
    trace data
    trace @whichdoc

    @evtHandler.net.body({
      data
    }).urlParams({
      uid : AppProps.uid,
      whichdoc : @whichdoc
    }).post('uploadkycdocumentimg')
    alert("Uploaded")
    data = JSON.parse(AppProps.get("accdata"))
    if data.accType is "COMPANY"
      trace " in company " + @whichdoc + " image camera "
      $('#'+@whichdoc+'Img').attr('src', "#{AppProps.root}/accounts/getkycfile/" + data.username + "/" + @whichdoc + '?timestamp=' + new Date().getTime())
    if data.accType is "INDIVIDUAL"
      trace " in individual " + @whichdoc + " image camera "
      $('#'+@whichdoc+'Image').attr('src', "#{AppProps.root}/accounts/getkycfile/" + data.username + "/" + @whichdoc + '?timestamp=' + new Date().getTime())

  cameraFail : (data) ->
    trace data
    alert "Something went wrong..."

  tmpl: (data) ->
    """
      <div class='bar bar-header bar-light'>
        <back class='button'>Back</back>
        <h1 class='title'>KYC Documents</h1>
        <logout class='button'>Logout</logout>
      </div>
    <div class='content2 content'>
      <div id='USER' style='display:none;'>
       <div  class='list list-inset'>
        <div>
         <div class='item'>
           <p><b>Non Photo ID:</b></p>
           <p id='NONPHOTOIDUploaded'>Placeholder</p>
           <div class='card'>
            <img id='NONPHOTOIDImage' style='width:100%;display:block;margin: 0 auto;' src=''>
           </div>
           <label for="NONPHOTOID" class="button" style='display:none;'>
              Choose file
           </label><br>
           <input class='button' type='file' id='NONPHOTOID' required style='display:none;'>
           <submit class='button' id='nonphotoidSubmit' style='display:none;'>Submit</submit>
           <takepicture class="button icon ion-camera"></takepicture>
           <button class='button'>Upload from gallery</button>
           <cancel class='button' style='display:none;'>Cancel</cancel>
         </div>
       </div>

       <div class='item'>
         <p><b>Photo ID:</b></p>
         <p id='PHOTOIDUploaded'>Placeholder</p>
         <div class='card'>
          <img class='full-image' id='PHOTOIDImage' style='width:100%;display:block;margin: 0 auto;' src=''>
         </div>
         <label for="PHOTOID" class="button" style='display:none;'>
             Choose file
         </label><br>
         <input type='file' id='PHOTOID' required style='display:none;'>
         <submit class='button' id='photoidSubmit' style='display:none;'>Submit</submit>
         <takepicture class="button icon ion-camera"></takepicture>
         <button class='button'>Upload from gallery</button>
         <cancel class='button' style='display:none;'>Cancel</cancel>
         <br>
       </div>
      </div>
     </div>

      <div id='Company' style='display:none;'>
       <div  class='list list-inset'>
         <div class='item'>
           <p><b>Photo ID:</b></p>
           <p id='PHOTOIDUpld'>Placeholder</p>
           <div class='card'>
            <img id='PHOTOIDImg' style='width:100%;display:block;margin: 0 auto;' src=''>
           </div>
           <label for="PHOTOIDZ" class="button" style='display:none;'>
              Choose file
           </label><br>
           <input type='file' id='PHOTOIDZ' required style='display:none;'>
           <submit class='button' id='photoidSubmit' style='display:none;'>Submit</submit>
           <takepicture class="button icon ion-camera"></takepicture>
           <button class='button'>Upload from gallery</button>
           <cancel class='button' style='display:none;'>Cancel</cancel>
           <br>
         </div>
          <div>
           <div class='item'>
             <p><b>Proof of Address:</b></p>
             <p id='NONPHOTOIDUpld'>Placeholder</p>
             <div class='card'>
              <img id='NONPHOTOIDImg' style='width:100%;display:block;margin: 0 auto;' src=''>
             </div>
             <label for="NONPHOTOIDZ" class="button" style='display:none;'>
              Choose file
             </label><br>
             <input type='file' id='NONPHOTOIDZ' required style='display:none;'>
             <submit class='button' id='nonphotoidSubmit' style='display:none;'>Submit</submit>
             <takepicture class="button icon ion-camera"></takepicture>
             <button class='button'>Upload from gallery</button>
             <cancel class='button' style='display:none;'>Cancel</cancel>
           </div>
         </div>
         <div class='item'>
           <p><b>Company Certificate:</b></p>
           <p id='COMPANYCERTIFICATEUpld'>Placeholder</p>
           <div class='card'>
            <img id='COMPANYCERTIFICATEImg' style='width:100%;display:block;margin: 0 auto;' src=''>
           </div>
           <label for="COMPANYCERTIFICATE" class="button" style='display:none;'>
              Choose file
           </label><br>
           <input type='file' id='COMPANYCERTIFICATE' required style='display:none;'>
           <submit class='button' id='companycertificateSubmit' style='display:none;'>Submit</submit>
           <takepicture class="button icon ion-camera"></takepicture>
           <button class='button'>Upload from gallery</button>
           <cancel class='button' style='display:none;'>Cancel</cancel>
           <br>
         </div>
         <div class='item'>
           <p><b>List of directors:</b></p>
           <p id='LISTOFDIRECTORSUpld'>Placeholder</p>
           <div class='card'>
            <img id='LISTOFDIRECTORSImg' style='width:100%;display:block;margin: 0 auto;' src=''>
           </div>
           <label for="LISTOFDIRECTORS" class="button" style='display:none;'>
              Choose file
           </label><br>
           <input type='file' id='LISTOFDIRECTORS' required style='display:none;'>
           <submit class='button' id='listofdirectorsSubmit' style='display:none;'>Submit</submit>
           <takepicture class="button icon ion-camera"></takepicture>
           <button class='button'>Upload from gallery</button>
           <cancel class='button' style='display:none;'>Cancel</cancel>
           <br>
         </div>
         <div class='item'>
           <p><b>List of shareholders:</b></p>
           <p id='LISTOFSHAREHOLDERSUpld'>Placeholder</p>
           <div class='card'>
            <img class='content content2' id='LISTOFSHAREHOLDERSImg' style='width:100%;display:block;margin: 0 auto;' src=''>
           </div>
           <label for="LISTOFSHAREHOLDERS" class="button" style='display:none;'>
              Choose file
           </label><br>
           <input type='file' id='LISTOFSHAREHOLDERS' required style='display:none;'>
           <submit class='button' id='listofshareholdersSubmit' style='display:none;'>Submit</submit>
           <takepicture class="button icon ion-camera"></takepicture>
           <button class='button'>Upload from gallery</button>
           <cancel class='button' style='display:none;'>Cancel</cancel>
           <br>
         </div>
      </div>
      </div>
     </div>
    """