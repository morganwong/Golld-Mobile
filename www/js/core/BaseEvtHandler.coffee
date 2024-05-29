class BaseEvtHandler
  constructor: (@view) ->
    @net = new BTNetEvt()
    @net.handler = @