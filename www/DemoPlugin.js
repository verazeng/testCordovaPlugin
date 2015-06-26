var exec = require('cordova/exec');

exports.alertView = function (options, success, error) {
  exec(success, error, "DemoPlugin", "alertView", [options]);
};

exports.getDeviceInfo = function (options, success, error) {
  exec(success, error, "DemoPlugin", "getDeviceInfo", [options]);
};

