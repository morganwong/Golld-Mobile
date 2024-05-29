var SplashEvtHandler,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

SplashEvtHandler = (function(_super) {
  __extends(SplashEvtHandler, _super);

  function SplashEvtHandler(view) {
    this.view = view;
    this.handleEvt = __bind(this.handleEvt, this);
    SplashEvtHandler.__super__.constructor.call(this, this.view);
  }

  SplashEvtHandler.prototype.handleEvt = function(name, data) {
    trace("in splash evthandler");
    if (name === 'error') {
      trace("error : " + data);
      return trace(data);
    }
  };

  return SplashEvtHandler;

})(BaseEvtHandler);
