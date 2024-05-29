class ViewsManager
  views : {}

  stack : []

  curView : null

  addView : (name, inst) =>
    trace @views
    if not @views[name]?
      trace "adding {" + name + "}"
      @views[name] = inst

  view : (name) => @views[name]

  init : (name, data) =>

    setTimeout () =>
      if @curView?
        trace 'moving to ' + name + ' from ' + @curView.name
        @stack.push {
          name : @curView.name
          data : @curView.data
        }

      trace 'attempt start of ' + name
      @views[name].init(data)
      @curView = {
        name : name
        data : data
      }
    , 10


  pop : =>
    v = @stack.pop()
    @views[v.name].init(v.data) if v?

class UI
  @viewMgr : null

  @viewMgrInst : ->
    @viewMgr = new ViewsManager() if not @viewMgr?
    @viewMgr

  @views : @viewMgrInst()

  @showLoader : ->
    if window.plugins?
      window.plugins.spinnerDialog.show(null, null, true)
#    if spinnerplugin?
#      spinnerplugin.show(
#        overlay: false,
#        fullscreen: true
#      )

  @hideLoader: ->
    if window.plugins?
      window.plugins.spinnerDialog.hide()
#    if spinnerplugin? then spinnerplugin.hide()

  @networkOK : ->
    if not navigator.connection? then return true

    if Connection?
      if navigator.connection.type == Connection.NONE
        alert "You must have an internet connection to continue."
        return false

    true
