var AppUtils;

AppUtils = {
  getWindowSizes: function() {
    var windowHeight, windowWidth;
    windowHeight = 0;
    windowWidth = 0;
    if (typeof window.innerWidth === 'number') {
      windowHeight = window.innerHeight;
      windowWidth = window.innerWidth;
    } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
      windowHeight = document.documentElement.clientHeight;
      windowWidth = document.documentElement.clientWidth;
    } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
      windowHeight = document.body.clientHeight;
      windowWidth = document.body.clientWidth;
    }
    return [windowWidth, windowHeight];
  },
  rad2deg: function(rad) {
    return rad * 180.0 / Math.PI;
  },
  deg2rad: function(deg) {
    return deg * Math.PI / 180.0;
  },
  distanceBetweenPoints: function(a, b) {
    var dist, theta;
    theta = a.lng - b.lng;
    dist = Math.sin(this.deg2rad(a.lat)) * Math.sin(this.deg2rad(b.lat)) + Math.cos(this.deg2rad(a.lat)) * Math.cos(this.deg2rad(b.lat)) * Math.cos(this.deg2rad(theta));
    dist = Math.acos(dist);
    dist = this.rad2deg(dist);
    dist = dist * 60 * 1.1515;
    dist = dist * 1.609344;
    return dist;
  },
  getAddress: function(a) {
    var b, cur, i, _i, _len;
    b = ['', '', '', ''];
    cur = 0;
    for (_i = 0, _len = a.length; _i < _len; _i++) {
      i = a[_i];
      if (i === ',') {
        cur++;
      } else {
        b[cur] += i;
      }
    }
    return b;
  }
};
