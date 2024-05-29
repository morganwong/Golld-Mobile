/*
  usage

  evt = new BTNetEvt()
  evt.link 'getCustomer', Links.rest.customerController.get
  evt.jsonContent().pathParams('1234', 'short').urlParams({
    email : 'test@test.com'
  }).body({
    detailed : 'true'
  }).post('getCustomer')
*/

var BTNetEvt, traceProps,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __slice = [].slice;

traceProps = function(o) {
  if ($.type(o) === "string") {
    return trace(o);
  } else if ($.type(o) === "object") {
    return trace(JSON.stringify(o, null, 2));
  } else {
    return trace(o);
  }
};

BTNetEvt = (function() {
  BTNetEvt.links = {};

  function BTNetEvt(handler) {
    this.handler = handler;
    this.getParts = __bind(this.getParts, this);
    this.handleFail = __bind(this.handleFail, this);
    this.handleOK = __bind(this.handleOK, this);
    this.invoke = __bind(this.invoke, this);
    this.put = __bind(this.put, this);
    this.patch = __bind(this.patch, this);
    this.post = __bind(this.post, this);
    this.get = __bind(this.get, this);
    this.bindEvtToLink = __bind(this.bindEvtToLink, this);
    this.headers = __bind(this.headers, this);
    this.verbose = __bind(this.verbose, this);
    this.body = __bind(this.body, this);
    this.urlParams = __bind(this.urlParams, this);
    this.pathParams = __bind(this.pathParams, this);
    this.defaultContent = __bind(this.defaultContent, this);
    this.jsonContent = __bind(this.jsonContent, this);
    this.timeout = __bind(this.timeout, this);
    this.contentType = __bind(this.contentType, this);
    this.loader = __bind(this.loader, this);
    this.getPackage = __bind(this.getPackage, this);
    this.events = {};
    this.exePackages = {};
  }

  BTNetEvt.prototype.link = function(name) {
    return BTNetEvt.links[name];
  };

  BTNetEvt.prototype.showSpinner = function() {
    return UI.showLoader();
  };

  BTNetEvt.prototype.hideSpinner = function() {
    return UI.hideLoader();
  };

  BTNetEvt.prototype.getPackage = function() {
    return this["package"] != null ? this["package"] : this["package"] = {
      contentType: "application/x-www-form-urlencoded",
      verbose: false,
      urlParams: {},
      loader: true,
      timeout: 60000
    };
  };

  BTNetEvt.prototype.loader = function(v) {
    this.getPackage().loader = v;
    return this;
  };

  BTNetEvt.prototype.contentType = function(v) {
    this.getPackage().contentType = v;
    return this;
  };

  BTNetEvt.prototype.timeout = function(v) {
    this.getPackage().timeout = v;
    return this;
  };

  BTNetEvt.prototype.jsonContent = function() {
    this.getPackage().contentType = "application/json";
    return this;
  };

  BTNetEvt.prototype.defaultContent = function() {
    this.getPackage().contentType = "application/x-www-form-urlencoded";
    return this;
  };

  BTNetEvt.prototype.pathParams = function() {
    var p, params, str, _i, _len;
    params = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    str = "/";
    for (_i = 0, _len = params.length; _i < _len; _i++) {
      p = params[_i];
      str += p + "/";
    }
    this.getPackage().pathParams = str;
    return this;
  };

  BTNetEvt.prototype.urlParams = function(urlParams) {
    this.getPackage().urlParams = urlParams;
    return this;
  };

  BTNetEvt.prototype.body = function(body) {
    this.getPackage().body = body;
    return this;
  };

  BTNetEvt.prototype.verbose = function(v) {
    this.getPackage().verbose = v;
    return this;
  };

  BTNetEvt.prototype.headers = function(k, v) {
    var _base;
    if ((_base = this.getPackage()).headers == null) {
      _base.headers = {};
    }
    this.getPackage().headers[k] = v;
    return this;
  };

  BTNetEvt.prototype.out = function() {
    trace("...links");
    trace(this.links);
    trace("...events");
    return trace(this.events);
  };

  BTNetEvt.prototype.bindEvtToLink = function(name, l) {
    return this.events[name] = l;
  };

  BTNetEvt.prototype.get = function(name) {
    return this.invoke('GET', name);
  };

  BTNetEvt.prototype.post = function(name) {
    return this.invoke('POST', name);
  };

  BTNetEvt.prototype.patch = function(name) {
    return this.invoke('PATCH', name);
  };

  BTNetEvt.prototype.put = function(name) {
    return this.invoke('PUT', name);
  };

  BTNetEvt.prototype.invoke = function(method, name) {
    var body, cb, link, pkg, pkgName, _ref,
      _this = this;
    if (!UI.networkOK()) {
      return;
    }
    _ref = this.getParts(name), link = _ref[0], cb = _ref[1], body = _ref[2];
    if (link == null) {
      if (this.getPackage().verbose) {
        trace('no link found for ' + name);
      }
      return;
    }
    if (cb == null) {
      if (this.getPackage().verbose) {
        trace('no handler found in this instance ' + this.handler);
      }
      return;
    }
    if (this.getPackage().verbose) {
      trace('.....invoke data for');
      trace('link ' + link);
      trace("event name " + name);
      trace("content : " + this.getPackage().contentType);
      trace("params : ");
      traceProps(this.getPackage().urlParams);
      trace("body : ");
      traceProps(this.getPackage().body);
      trace('headers : ' + this.getPackage().headers);
      trace('.....invoke data end');
    }
    if (this.getPackage().loader) {
      this.showSpinner();
    }
    pkgName = "_exe_" + (Math.random() * 99999);
    this.exePackages[pkgName] = this.getPackage();
    this["package"] = null;
    pkg = this.exePackages[pkgName];
    trace('invoking ' + link);
    return $.ajax({
      url: link,
      dataType: "text",
      contentType: pkg.contentType,
      data: body,
      processData: false,
      type: method,
      headers: pkg.headers,
      timeout: pkg.timeout,
      success: function(data) {
        return _this.handleOK(name, data, pkgName, cb, link);
      },
      error: function(x, e, s) {
        return _this.handleFail(cb, link, pkgName, x, e, s);
      }
    });
  };

  BTNetEvt.prototype.handleOK = function(name, data, pkgName, cb, link) {
    var pkg;
    trace('invoke of ' + link + ' completed');
    this.hideSpinner();
    pkg = this.exePackages[pkgName];
    if (pkg.verbose) {
      trace('we have data from ' + link);
      trace(data);
    }
    this.exePackages[pkgName] = null;
    return cb(name, data);
  };

  BTNetEvt.prototype.handleFail = function(cb, link, pkgName, x, e, s) {
    var pkg;
    trace('invoke of ' + link + ' failed');
    this.hideSpinner();
    pkg = this.exePackages[pkgName];
    if (pkg.verbose) {
      trace('we have error from ' + link);
      trace(e);
      trace(traceProps(x.statusCode()));
      trace(x.statusText);
    }
    this.exePackages[pkgName] = null;
    return cb('error', e, x);
  };

  BTNetEvt.prototype.getParts = function(name) {
    var body, bodys, k, link, pParams, s, urlParams, v, _ref, _ref1;
    if (this.getPackage().body != null) {
      if ($.type(this.getPackage().body) === "object") {
        if (this.getPackage().contentType === "application/json") {
          body = JSON.stringify(this.getPackage().body);
        } else {
          bodys = "";
          _ref = this.getPackage().body;
          for (k in _ref) {
            v = _ref[k];
            bodys += "" + (encodeURIComponent(k)) + "=" + (encodeURIComponent(v)) + "&";
          }
          body = bodys;
        }
      }
    }
    urlParams = "";
    s = "";
    if (this.getPackage().urlParams != null) {
      if ($.type(this.getPackage().urlParams) === "string") {
        s = this.getPackage().urlParams;
      } else if ($.type(this.getPackage().urlParams) === "object") {
        s = "?";
        _ref1 = this.getPackage().urlParams;
        for (k in _ref1) {
          v = _ref1[k];
          s += "" + (encodeURIComponent(k)) + "=" + (encodeURIComponent(v)) + "&";
        }
      }
    }
    pParams = this.getPackage().pathParams;
    if (pParams == null) {
      pParams = "";
    }
    link = this.events[name] + pParams + s;
    return [link, this.handler['handleEvt'], body];
  };

  return BTNetEvt;

})();
