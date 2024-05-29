var AppProps;

AppProps = {
  root: "https://golldvouchers.herokuapp.com/m",
  store: function(k, v) {
    return localStorage.setItem(k, v);
  },
  get: function(k) {
    return localStorage.getItem(k);
  },
  userMail: function() {
    return AppProps.getUserEmailFromLocalStorage();
  },
  setUserMail: function(e) {
    return localStorage.setItem('tm_q_114349yuym5z_', e);
  },
  getUserEmailFromLocalStorage: function() {
    return localStorage.getItem('tm_q_114349yuym5z_');
  },
  logout: function() {
    AppProps.setUserMail(null);
    AppProps.uid = null;
    return localStorage.clear();
  }
};
