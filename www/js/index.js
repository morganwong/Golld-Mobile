var deviceReady;

deviceReady = function() {
  trace('we are ready');
  new SplashView();
  new LoginCreateGolldView();
  new AccountGolldView();
  window.alert = function(msg, title, ok) {
    if (title == null) {
      title = 'Alert';
    }
    if (ok == null) {
      ok = 'OK';
    }
    if ((typeof navigator !== "undefined" && navigator !== null ? navigator.notification : void 0) != null) {
      return navigator.notification.alert(msg, null, title, ok);
    } else {
      return trace('ALERT!!!!!!!!! ' + msg);
    }
  };
  return UI.views.init("SplashView");
};

$(document).ready(function() {
  return $(document).bind("deviceready", deviceReady);
});
