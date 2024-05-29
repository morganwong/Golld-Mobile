var BaseView, traceObj,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

traceObj = function(o) {
  var k, v, _results;
  _results = [];
  for (k in o) {
    v = o[k];
    _results.push(trace(k + ' : ' + v));
  }
  return _results;
};

BaseView = (function() {
  BaseView.phoneBound = false;

  BaseView.contentID = "#id_mainContent";

  BaseView.bindPhoneBackButton = function(cb) {
    if (cb != null) {
      $(document).unbind("backbutton");
      $(document).bind("backbutton", function() {
        return cb();
      });
      return trace('custom back from phone button is set up...');
    }
    $(document).unbind("backbutton");
    $(document).bind("backbutton", function() {
      trace('attempting back from phone button...');
      return UI.views.init('home');
    });
    return trace('back from phone button is set up...');
  };

  BaseView.prototype.template = function() {};

  function BaseView(name) {
    this.name = name;
    this.dismissConfirmPopup = __bind(this.dismissConfirmPopup, this);
    this.injectUI = __bind(this.injectUI, this);
    UI.views.addView(this.name, this);
    trace("ctord " + this.name);
    this.defaultOpts = {
      bindBack: true,
      cache: false,
      classes: ["app"],
      consoleClear: false,
      mobileBackBtn: null
    };
  }

  BaseView.prototype.injectUI = function(opts) {
    var c, tmpl, _i, _len, _ref;
    $('html, body').animate({
      scrollTop: 0
    }, 0);
    if (opts == null) {
      opts = {};
    }
    opts = $.extend(this.defaultOpts, opts);
    traceObj(opts);
    traceObj(this.defaultOpts);
    if (this.defaultOpts.consoleClear && (console.clear != null)) {
      console.clear();
    }
    BaseView.bindPhoneBackButton(opts.mobileBackBtn);
    tmpl = this.template();
    $(BaseView.contentID).html(this.template());
    if (opts.bindBack) {
      this.bindBack();
    }
    $(BaseView.contentID).removeClass();
    _ref = opts.classes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      c = _ref[_i];
      $(BaseView.contentID).addClass(c);
    }
    return trace("base injectUI done...");
  };

  BaseView.prototype.bindBack = function() {
    trace('binding back link');
    $('[data-back]').each(function() {
      return $(this).click(function() {
        var target;
        target = $(this).attr('data-back');
        trace('bac to....' + target);
        return trace('completed');
      });
    });
    return trace('back links bound...');
  };

  BaseView.prototype.bindInputChange = function() {
    return $("input[type='text'], input[type='number'], input[type='password']").change(function() {
      return ViewsManager.hideKeyboard();
    });
  };

  BaseView.prototype.validate = function() {
    $("input[type='text'],input[type='password'],input[type='number'],input[type='datetime'],input[type='email'],input[type='date']").each(function() {
      var v;
      if ($(this).attr('data-validateOff') == null) {
        v = $(this).val();
        if (v.length === 0) {
          if ($(this).attr('data-vld-msg')) {
            alert($(this).attr('data-vld-msg'));
            return false;
          }
        }
      }
    });
    $("input[type='number']").each(function() {
      var max, min, v;
      if ($(this).attr('data-validateOff') == null) {
        v = parseInt($(this).val());
        min = $(this).attr('min');
        max = $(this).attr('max');
        if (v < min) {
          if ($(this).attr('data-vld-msg-min')) {
            alert($(this).attr('data-vld-msg-min'));
            return false;
          }
        }
        if (v > max) {
          if ($(this).attr('data-vld-msg-max')) {
            alert($(this).attr('data-vld-msg-max'));
            return false;
          }
        }
      }
    });
    return true;
  };

  BaseView.prototype.customAlertPopup = function() {
    return $(BaseView.contentID).prepend("<div class='cl_hidden' id='modal_alert'>\n  <div class='alert_modal cl_hidden' id='alert_modal'>\n    <div style='min-height: 60%'>\n      <p id='customAlert_text' style='font-size: medium'></p>\n    </div>\n    <div style='margin-bottom: 5% !important'>\n      <div style='margin-left: 10% !important; margin-right: 15% !important; width: 60%' class='popupBtn cl_hidden' id='alert_close_btn'>OK</div>\n    </div>\n  </div>\n</div>");
  };

  BaseView.prototype.callAlertPopup = function(msg) {
    $('#modal_alert').addClass('overlay');
    $('#modal_alert').removeClass('cl_hidden');
    $('#modal_alert').css({
      'z-index': '998'
    });
    $('#alert_modal').css({
      'z-index': '999'
    });
    $('#alert_modal').removeClass('cl_hidden');
    $('#alert_close_btn').removeClass('cl_hidden');
    $('html, body').animate({
      scrollTop: "0px"
    }, "fast");
    $('#customAlert_text').prepend(msg);
    return trace("customAlert!!" + msg);
  };

  BaseView.prototype.dismissAlertPopup = function() {
    $('#modal_alert').removeClass('overlay');
    $('#modal_alert').addClass('cl_hidden');
    $('#modal_alert').css({
      'z-index': '-1'
    });
    $('#alert_modal').css({
      'z-index': '-1'
    });
    $('#alert_modal').addClass('cl_hidden');
    $('#alert_close_btn').addClass('cl_hidden');
    return $('#customAlert_text').text("");
  };

  BaseView.prototype.customConfirmPopup = function() {
    return $(BaseView.contentID).prepend(" <div id='confirm_modal' class='confirm_modal cl_hidden'>\n  <p id='customConfirm_text' style='font-size: medium; font-weight: bold;'></p>\n  <button id='modal_confirm_btn' class='button button-block popupBtn cl_hidden'>Confirm</button>\n  <button id='modal_cancel_btn' class='button button-block popupBtn cl_hidden'>Cancel</button>\n</div>");
  };

  BaseView.prototype.callConfirmPopup = function(msg) {
    $('#confirm_modal').css({
      'z-index': '999'
    });
    $('#confirm_modal').removeClass('cl_hidden');
    $('#modal_confirm_btn').removeClass('cl_hidden');
    $('#modal_cancel_btn').removeClass('cl_hidden');
    return $('#customConfirm_text').prepend(msg);
  };

  BaseView.prototype.dismissConfirmPopup = function() {
    $('#confirm_modal').addClass('cl_hidden');
    $('#confirm_modal').css({
      'z-index': '-1'
    });
    $('#modal_confirm_btn').addClass('cl_hidden');
    $('#modal_cancel_btn').addClass('cl_hidden');
    return $('#customConfirm_text').text("");
  };

  BaseView.prototype.customWorkingPopup = function(msg) {
    $(BaseView.contentID).prepend("<div class='cl_hidden' id='modal_working'>\n  <div class='alert_modal cl_hidden' id='working_modal'>\n    <p id='customWorking_text' style='font-size: medium; font-weight: bold; '>\n    <img src='img/loading.svg' style='position: absolute; margin: auto; left: 0; top: 0; right: 0; bottom: 0; z-index: 250;'>\n    </p>\n  </div>\n</div>");
    return $('#customWorking_text').prepend(msg);
  };

  BaseView.prototype.callWorkingPopup = function() {
    $('#modal_working').addClass('overlay');
    $('#working_modal').removeClass('cl_hidden');
    $('#modal_working').removeClass('cl_hidden');
    $('#modal_working').css({
      'z-index': '999'
    });
    return $('#working_modal').css({
      'z-index': '999'
    });
  };

  BaseView.prototype.dismissWorkingPopup = function() {
    $('#modal_working').removeClass('overlay');
    $('#working_modal').removeClass('modal-content');
    $('#working_modal').addClass('cl_hidden');
    $('#modal_working').addClass('cl_hidden');
    $('#modal_working').css({
      'z-index': '-1'
    });
    $('#working_modal').css({
      'z-index': '-1'
    });
    return $('#customWorking_text').text("");
  };

  BaseView.prototype.setAppWideLanguage = function(l) {
    switch (l) {
      case "EN":
        lOpts.Lang = lOpts.Lang_EN;
        break;
      case "ES":
        lOpts.Lang = lOpts.Lang_ES;
        break;
      case "DE":
        lOpts.Lang = lOpts.Lang_DE;
    }
    AppUtils.putFile("LangPref", l);
  };

  return BaseView;

})();
