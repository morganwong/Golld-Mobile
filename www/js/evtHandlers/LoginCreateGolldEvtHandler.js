var LoginCreateGolldEvtHandler,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

LoginCreateGolldEvtHandler = (function(_super) {
  __extends(LoginCreateGolldEvtHandler, _super);

  function LoginCreateGolldEvtHandler(view) {
    this.view = view;
    this.handleEvt = __bind(this.handleEvt, this);
    LoginCreateGolldEvtHandler.__super__.constructor.call(this, this.view);
  }

  LoginCreateGolldEvtHandler.prototype.handleEvt = function(name, data) {
    trace("in login create golld evthandler");
    if (name === "login") {
      trace("login!!!");
      trace(data);
      if (data === "User not found" || data === "Password incorrect") {
        trace("IF IS TRUE !!!");
        alert(data);
      } else {
        trace("ELSE IS HERE !!!");
        AppProps.uid = data;
        UI.views.init("AccountGolldView");
        trace("FINISH");
      }
    }
    if (name === "create") {
      trace("create");
      if (data.indexOf("ERROR - " !== -1)) {
        alert(data.susbtring(8));
      } else {
        alert("Account created");
        AppProps.uid = data;
      }
    }
    if (name === 'error') {
      trace("error : " + data);
      return trace(data);
    }
  };

  return LoginCreateGolldEvtHandler;

})(BaseEvtHandler);
