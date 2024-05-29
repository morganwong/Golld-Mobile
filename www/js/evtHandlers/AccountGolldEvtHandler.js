var AccountGolldEvtHandler,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

AccountGolldEvtHandler = (function(_super) {
  __extends(AccountGolldEvtHandler, _super);

  function AccountGolldEvtHandler(view) {
    this.view = view;
    this.handleEvt = __bind(this.handleEvt, this);
    AccountGolldEvtHandler.__super__.constructor.call(this, this.view);
  }

  AccountGolldEvtHandler.prototype.handleEvt = function(name, data) {
    trace("in account golld evthandler");
    if (name === 'error') {
      trace("error : " + data);
      return trace(data);
    }
  };

  return AccountGolldEvtHandler;

})(BaseEvtHandler);
