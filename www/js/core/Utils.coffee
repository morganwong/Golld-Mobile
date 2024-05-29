AppUtils = {
  getWindowSizes: ->
    windowHeight = 0
    windowWidth = 0
    if (typeof (window.innerWidth) == 'number')
      windowHeight = window.innerHeight
      windowWidth = window.innerWidth
    else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight))
      windowHeight = document.documentElement.clientHeight
      windowWidth = document.documentElement.clientWidth
    else if (document.body && (document.body.clientWidth || document.body.clientHeight))
      windowHeight = document.body.clientHeight
      windowWidth = document.body.clientWidth

    [windowWidth, windowHeight]

  rad2deg : (rad) ->
    rad * 180.0 / Math.PI

  deg2rad : (deg) ->
    deg * Math.PI / 180.0

  distanceBetweenPoints : (a, b) ->
    theta = a.lng - b.lng
    dist = Math.sin(@deg2rad(a.lat)) * Math.sin(@deg2rad(b.lat)) + Math.cos(@deg2rad(a.lat)) * Math.cos(@deg2rad(b.lat)) * Math.cos(@deg2rad(theta))

    dist = Math.acos(dist)
    dist = @rad2deg(dist)
    dist = dist * 60 * 1.1515
    dist = dist * 1.609344
    dist

  getAddress : (a) ->
    b = [ '', '', '', '' ]
    cur = 0
    for i in a
      if i is ','
        cur++
      else
        b[cur] += i

    b

  errorHandler : (e, err) =>
    trace err

  getFile : (fileName) =>
    trace "attempting to get file : " + cordova.file.dataDirectory + fileName

    ct = null
    $.ajax(
      type: 'GET',
      url: cordova.file.dataDirectory + fileName,
      async: false, # so ajax call doesn't run in a seperate thread, this way, returned 'ct' is 'content' and not 'null'
      success: (content) =>
        if content.length > 0
          ct = content
      error: (err) =>
        ct = "ERROR"
    )

    return ct

  saveToFile : (fileName, contents) ->
    trace "attempting to save data to '" + fileName + "'"

    window.resolveLocalFileSystemURL(cordova.file.dataDirectory, (dirEntry) =>
      dirEntry.getFile(fileName, {create:true}, (fileEntry) =>
        $.ajax
          type: 'GET',
          url: cordova.file.dataDirectory + fileName,
          async: false,
          success: (unused_) =>
            fileEntry.createWriter( (fileWriter) =>

              fileWriter.onwriteend = (e) =>
                trace 'Write of file "' + fileName + '" completed.'
                trace JSON.stringify(e)

              fileWriter.onerror = (e) =>
                trace 'Write failed: ' + e.toString()

              arr = []
              arr[0] = contents

              trace "Final Write : " + arr[0]

              blob = new Blob(arr, {type:'text/plain'})
              fileWriter.write(blob)

            , AppUtils.errorHandler.bind(null, fileName))
          error: (err) =>
            trace "AJAX error !"
            trace JSON.stringify err

            fileEntry.createWriter( (fileWriter) =>

              fileWriter.onwriteend = (e) =>
                trace 'Write of file "' + fileName + '" completed.'

              fileWriter.onerror = (e) =>
                trace 'Write failed: ' + e.toString()

              arr = []
              arr[0] = contents

              blob = new Blob(arr, {type:'text/plain'})
              fileWriter.write(blob)

            , AppUtils.errorHandler.bind(null, fileName))
      , AppUtils.errorHandler.bind(null, fileName))
    )

}
