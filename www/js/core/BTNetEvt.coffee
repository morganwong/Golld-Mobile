###
  usage

  evt = new BTNetEvt()
  evt.link 'getCustomer', Links.rest.customerController.get
  evt.jsonContent().pathParams('1234', 'short').urlParams({
    email : 'test@test.com'
  }).body({
    detailed : 'true'
  }).post('getCustomer')
###

traceProps = (o) ->
  if $.type(o) is "string"
    trace o
  else if $.type(o) is "object"
    trace JSON.stringify(o, null, 2)
  else
    trace o

class BTNetEvt
  @links : {}

  constructor:(@handler) ->
    @events = {}
    @exePackages = {}

  link : (name) -> return BTNetEvt.links[name]
  showSpinner : -> UI.showLoader()
  hideSpinner : -> UI.hideLoader()

  getPackage : =>
    @package ?= {
      contentType : "application/x-www-form-urlencoded"
      verbose : false
      urlParams : {}
      loader : true
      timeout : 60000
    }

  loader : (v) =>
    @getPackage().loader = v
    @

  contentType :(v) =>
    @getPackage().contentType = v
    @

  timeout :(v) =>
    @getPackage().timeout = v
    @

  jsonContent : =>
    @getPackage().contentType = "application/json"
    @

  defaultContent : =>
    @getPackage().contentType = "application/x-www-form-urlencoded"
    @

  pathParams : (params...) =>
    str = "/"
    str += p + "/" for p in params
    @getPackage().pathParams = str
    @

  urlParams : (urlParams) =>
    @getPackage().urlParams = urlParams
    @

  body : (body) =>
    @getPackage().body = body
    @

  verbose : (v) =>
    @getPackage().verbose = v
    @

  headers : (k, v) =>
    @getPackage().headers ?= {}
    @getPackage().headers[k] = v
    @

  out : ->
    trace "...links"
    trace @links
    trace "...events"
    trace @events

  bindEvtToLink : (name, l) => @events[name] = l

  get : (name) => @invoke 'GET', name
  post : (name) => @invoke 'POST', name
  patch : (name) => @invoke 'PATCH', name
  put : (name) => @invoke 'PUT', name

  invoke : (method, name) =>
    if not UI.networkOK() then return
    [link, cb, body] = @getParts(name)

    if not link?
      if @getPackage().verbose then trace 'no link found for ' + name
      return

    if not cb?
      if @getPackage().verbose then trace 'no handler found in this instance ' + @handler
      return

    if @getPackage().verbose
      trace '.....invoke data for'
      trace 'link ' + link
      trace "event name " + name
      trace "content : " + @getPackage().contentType
      trace "params : "
      traceProps @getPackage().urlParams
      trace "body : "
      traceProps @getPackage().body
      trace 'headers : ' + @getPackage().headers
      trace '.....invoke data end'


    if name isnt "poll"
      if @getPackage().loader then @showSpinner()

    pkgName = "_exe_" + (Math.random() * 99999)
    @exePackages[pkgName] = @getPackage()
    @package = null

    pkg = @exePackages[pkgName]

    trace 'invoking ' + link
    $.ajax {
      url : link
      dataType : "text"
      contentType : pkg.contentType
      data : body
      processData : false
      type : method
      headers : pkg.headers
      timeout : pkg.timeout
      success : (data) => @handleOK(name, data, pkgName, cb, link)
      error : (x, e, s) => @handleFail(cb, link, pkgName, x, e, s)
    }

  handleOK : (name, data, pkgName, cb, link) =>
    trace 'invoke of ' + link + ' completed'
    @hideSpinner()
    pkg = @exePackages[pkgName]
    if pkg.verbose
      trace 'we have data from ' + link
      trace data

    @exePackages[pkgName] = null
    cb(name, data)

  handleFail : (cb, link, pkgName, x, e, s) =>
    trace 'invoke of ' + link + ' failed'
    @hideSpinner()
    pkg = @exePackages[pkgName]
    if pkg.verbose
      trace 'we have error from ' + link
      trace e
      trace traceProps x.statusCode()
      trace x.statusText

    @exePackages[pkgName] = null
    cb('error', e, x)

  getParts : (name) =>

    if @getPackage().body?
      if $.type(@getPackage().body) is "object"
        if @getPackage().contentType is "application/json"
          body = JSON.stringify(@getPackage().body)
        else
          bodys = ""
          for k, v of @getPackage().body
            bodys += "#{encodeURIComponent(k)}=#{encodeURIComponent(v)}&"

          body = bodys

    urlParams = ""
    s = ""

    if @getPackage().urlParams?
      if $.type(@getPackage().urlParams) is "string"
        s = @getPackage().urlParams
      else if $.type(@getPackage().urlParams) is "object"
        s = "?"
        for k, v of @getPackage().urlParams
          s += "#{encodeURIComponent(k)}=#{encodeURIComponent(v)}&"

    pParams = @getPackage().pathParams
    pParams ?= ""

    link = @events[name] + pParams + s

    [ link, @handler['handleEvt'], body]