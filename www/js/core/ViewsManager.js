var UI, ViewsManager,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ViewsManager = (function() {
  function ViewsManager() {
    this.pop = __bind(this.pop, this);
    this.init = __bind(this.init, this);
    this.view = __bind(this.view, this);
    this.addView = __bind(this.addView, this);
  }

  ViewsManager.prototype.views = {};

  ViewsManager.prototype.stack = [];

  ViewsManager.prototype.curView = null;

  ViewsManager.prototype.addView = function(name, inst) {
    trace(this.views);
    if (this.views[name] == null) {
      trace("adding {" + name + "}");
      return this.views[name] = inst;
    }
  };

  ViewsManager.prototype.view = function(name) {
    return this.views[name];
  };

  ViewsManager.prototype.init = function(name, data) {
    if (this.curView != null) {
      trace('moving to ' + name + ' from ' + this.curView.name);
      this.stack.push({
        name: this.curView.name,
        data: this.curView.data
      });
    }
    trace('attempt start of ' + name);
    this.views[name].init(data);
    return this.curView = {
      name: name,
      data: data
    };
  };

  ViewsManager.prototype.pop = function() {
    var v;
    v = this.stack.pop();
    if (v != null) {
      return this.views[v.name].init(v.data);
    }
  };

  return ViewsManager;

})();

UI = (function() {
  function UI() {}

  UI.viewMgr = null;

  UI.viewMgrInst = function() {
    if (this.viewMgr == null) {
      this.viewMgr = new ViewsManager();
    }
    return this.viewMgr;
  };

  UI.views = UI.viewMgrInst();

  UI.showLoader = function() {
    if (window.plugins != null) {
      return window.plugins.spinnerDialog.show(null, null, true);
    }
  };

  UI.hideLoader = function() {
    if (window.plugins != null) {
      return window.plugins.spinnerDialog.hide();
    }
  };

  UI.networkOK = function() {
    if (navigator.connection == null) {
      return true;
    }
    if (navigator.connection.type === Connection.NONE) {
      alert("You must have an internet connection to continue.");
      return false;
    }
    return true;
  };

  return UI;

})();
