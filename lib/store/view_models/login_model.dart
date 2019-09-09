import 'package:flutter_app/public_index.dart';

import '../../api/api_service.dart';
import '../../provider/view_state_model.dart';

const String kUserName = 'login_user_name';
const String kUserCode = 'login_user_code';
const String kPwd = 'login_password';

///是否自动登录
const String kAutoLogin = "login_auto_login";

/// 是否记住密码
const String kRememberPwd = "login_remember_pwd";

class LoginModel extends ViewStateModel {
  String _userName;

  String get userName => _userName;
  String _userCode;

  String get userCode => _userCode;
  String _pwd;

  String get pwd => _pwd;
  bool _autoLoginFlag;

  bool get autoLoginFlag => _autoLoginFlag;
  bool _rememberPwdFlag;

  bool get rememberPwdFlag => _rememberPwdFlag;

  LoginModel() {
    _userName = SpUtil.getString(kUserName);
    _userCode = SpUtil.getString(kUserCode);
    _pwd = SpUtil.getString(kPwd);
    _autoLoginFlag = SpUtil.getBool(kAutoLogin, defValue: false);
    _rememberPwdFlag = SpUtil.getBool(kRememberPwd, defValue: false);
  }

  Future<UserEntity> login(loginName, password) async {
    setBusy(true);
    try {
      UserEntity userEntity =
          await ApiService.getInstance().getLogin(loginName, password);
      setBusy(false);
      return userEntity;
    } catch (e) {
      setError(e is Error ? e.toString() : e.message);
      return null;
    }
  }

  void setUser(String userName, String userCode, String pwd) {
    this._userName = userName;
    this._userCode = userCode;
    this._pwd = pwd;
    notifyListeners();
    SpUtil.setString(kUserName, userName);
    SpUtil.setString(kUserCode, userCode);
    SpUtil.setString(kPwd, pwd);
  }

  void setAutoLoginOrPwd({bool autoLoginFlag, bool rememberPwdFlag}) {
    _autoLoginFlag = autoLoginFlag ?? _autoLoginFlag;
    if (_autoLoginFlag) {
      rememberPwdFlag = true;
    }
    _rememberPwdFlag = rememberPwdFlag ?? _rememberPwdFlag;
    if (!_rememberPwdFlag) {
      _autoLoginFlag = false;
      SpUtil.remove(kUserName);
      SpUtil.remove(kUserCode);
      SpUtil.remove(kPwd);
    }
    notifyListeners();
    SpUtil.setBool(kAutoLogin, _autoLoginFlag);
    SpUtil.setBool(kRememberPwd, _rememberPwdFlag);
  }
}
