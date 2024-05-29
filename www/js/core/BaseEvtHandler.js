var BaseEvtHandler;

BaseEvtHandler = (function() {
  function BaseEvtHandler(view) {
    this.view = view;
    this.net = new BTNetEvt();
    this.net.handler = this;
  }

  return BaseEvtHandler;

})();
