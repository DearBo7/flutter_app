import 'package:flutter_app/public_index.dart';

import '../../api/formula_api_service.dart';
import '../../provider/view_state_model.dart';

class LoginModel extends ViewStateModel {
  static const String kUserName = 'login_user_name';
  static const String kUserCode = 'login_user_code';
  static const String kPwd = 'login_password';

  ///是否自动登录
  static const String kAutoLogin = "login_auto_login";

  /// 是否记住密码
  static const String kRememberPwd = "login_remember_pwd";

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

  List<UserEntity> _userList;

  List<UserEntity> get userList => _userList;

  LoginModel() {
    _userName = SpUtil.getString(kUserName, defValue: null);
    _userCode = SpUtil.getString(kUserCode, defValue: null);
    _pwd = SpUtil.getString(kPwd, defValue: null);
    _autoLoginFlag = SpUtil.getBool(kAutoLogin, defValue: false);
    _rememberPwdFlag = SpUtil.getBool(kRememberPwd, defValue: false);
    _userList = [];
  }

  Future<UserEntity> login(loginName, password) async {
    setBusy(true);
    try {
      UserEntity userEntity =
          await FormulaApiService.getInstance().getLogin(loginName, password);
      setBusy(false);
      return userEntity;
    } catch (e) {
      setError(e is Error ? e.toString() : e.message);
      return null;
    }
  }

  void setUserInfo(String userName, String userCode, String pwd) {
    this._userName = userName;
    this._userCode = userCode;
    this._pwd = pwd;
    notifyListeners();
    SpUtil.setString(kUserName, userName);
    SpUtil.setString(kUserCode, userCode);
    SpUtil.setString(kPwd, pwd);
  }

  /// 设置自动登录
  void setAutoLogin(bool autoLoginFlag) {
    if (this._autoLoginFlag != autoLoginFlag) {
      this._autoLoginFlag = autoLoginFlag;
      notifyListeners();
      SpUtil.setBool(kAutoLogin, this._autoLoginFlag);
    }
  }

  /// 设置记住密码
  void setRememberPwd(bool rememberPwdFlag) {
    this._rememberPwdFlag = rememberPwdFlag;
    if (!this._rememberPwdFlag) {
      this._userName = null;
      this._userCode = null;
      this._pwd = null;
      setAutoLogin(false);
      SpUtil.remove(kUserName);
      SpUtil.remove(kUserCode);
      SpUtil.remove(kPwd);
    }
    notifyListeners();
    SpUtil.setBool(kRememberPwd, this._rememberPwdFlag);
  }

  //设置用户列表
  void setUserList(List<UserEntity> userList) {
    if (userList == null || userList.length < 0) {
      return;
    }
    if (_userList.length > 0) {
      _userList.clear();
    }
    _userList.addAll(userList);
    notifyListeners();
  }
}
