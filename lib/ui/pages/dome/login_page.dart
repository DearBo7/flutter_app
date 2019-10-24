import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/widget/custom/custom_widgets.dart';

import '../../../public_index.dart';
import '../../widget/button/button_progress_indicator.dart';
import '../../widget/login/login_field_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  // 上次点击时间
  DateTime _lastPressedAt;

  // 用户账号列表
  List<DropdownMenuItem<String>> _dropdownMenuItemList = [];

  // 用户code
  String _userCodeValue;

  // 自动登录
  bool _autoLoginFlag = false;

  // 记住密码
  bool _rememberPwdFlag = false;

  // 密码
  TextEditingController _passwordController = TextEditingController();

  //当前请求的api-输入框
  TextEditingController _apiUrlController = TextEditingController();

  //当前请求的api值
  String apiRestUrlValue;

  static const Color loginGradientStart = const Color(0xFFfbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      /// 加载用户信息
      getUserList(initLoginDataFlag: true);
    });
    apiRestUrlValue =
        SpUtil.getString(ApiUrl.kRestUrl, defValue: ApiUrl.RestUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                /*image: DecorationImage(
                  image: AssetImage("assets/images/login_bg.jpg"),
                  fit: BoxFit.fill,
                ),*/
                gradient: LinearGradient(
                  colors: const [loginGradientStart, loginGradientEnd],
                  stops: const [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LoginFormContainer(
                    child: Form(
                      key: _formKey,
                      //在请求的时候,阻止点击返回
                      onWillPop: () async {
                        //如果不是在请求时,判断是否返回两次
                        if (!Store.value<LoginModel>(context).busy) {
                          if (_lastPressedAt == null ||
                              DateTime.now().difference(_lastPressedAt) >
                                  Duration(seconds: 1)) {
                            //两次点击间隔超过1秒则重新计时
                            _lastPressedAt = DateTime.now();
                            ToastUtil.show(S.of(context).promptExit);
                            return false;
                          }
                          return true;
                        }
                        return false;
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            //用户列表
                            GestureDetector(
                              onTap: _dropdownMenuItemList.isNotEmpty
                                  ? null
                                  : () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  S.of(context).dialogPrompt),
                                              content: Text(S
                                                  .of(context)
                                                  .dialogNotUserMsg),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child:
                                                      Text(S.of(context).labNo),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    getUserList(
                                                        initLoginDataFlag:
                                                            false,
                                                        reloadFlag: true);
                                                  },
                                                  child: Text(
                                                      S.of(context).labYes),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  prefixIcon: InkWell(
                                    onDoubleTap: () {
                                      _apiUrlController.text = apiRestUrlValue;
                                      showDialog(
                                          context: context,
                                          //弹出框外不能取消
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("请求接口管理"),
                                              titlePadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              contentPadding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              content: Container(
                                                width: Utils.width,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    RowLabelToWidgetOne(
                                                      Text("默认Api接口:"),
                                                      rightWidget:
                                                          Text(ApiUrl.RestUrl),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            fontSize: Dimens
                                                                .font_sp16),
                                                        controller:
                                                            _apiUrlController,
                                                        keyboardType:
                                                            TextInputType.url,
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    right: 5,
                                                                    top: 24),
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                "当前Api地址:"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                //操作按钮数组
                                                RaisedButtons(
                                                  type: ButtonEnum.Cancel,
                                                  child: Text(
                                                      S.of(context).btnCancel),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                RaisedButtons(
                                                  type: ButtonEnum.Update,
                                                  child: Text(
                                                      S.of(context).btnUpdate),
                                                  onPressed: () {
                                                    String url = _checkUrl(
                                                        _apiUrlController.text);
                                                    if (url != null) {
                                                      apiRestUrlValue = url;
                                                      SpUtil.setString(
                                                          ApiUrl.kRestUrl,
                                                          apiRestUrlValue);
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                                RaisedButtons(
                                                  type: ButtonEnum.Confirm,
                                                  child: Text("重新加载"),
                                                  onPressed: () {
                                                    String url = _checkUrl(
                                                        _apiUrlController.text);
                                                    if (url != null) {
                                                      apiRestUrlValue = url;
                                                      SpUtil.setString(
                                                          ApiUrl.kRestUrl,
                                                          apiRestUrlValue);
                                                      getUserList(
                                                          reloadFlag: true);
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Icon(Icons.person_outline,
                                        color: Theme.of(context).accentColor,
                                        size: 22),
                                  ),
                                ),
                                //无匹配显示
                                hint: Text(_dropdownMenuItemList.isEmpty
                                    ? "暂无账号信息"
                                    : "请选择账号"),
                                items: _dropdownMenuItemList,
                                value: _userCodeValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _userCodeValue = newValue;
                                  });
                                },
                                validator: (text) {
                                  //todo text 初始化加载时,然后设置value值，验证时这个为null?
                                  print(
                                      "validator===>text:$text,_userCodeValue:$_userCodeValue");
                                  return _userCodeValue == null ||
                                          _userCodeValue.isEmpty
                                      ? "请选择账号"
                                      : null;
                                },
                              ),
                            ),
                            LoginTextField(
                              label: S.of(context).password,
                              icon: Icons.lock_outline,
                              controller: _passwordController,
                              obscureText: true,
                              maxLength: 16,
                              errorText: "请输入密码",
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Checkbox(
                                  value: _rememberPwdFlag,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _rememberPwdFlag = value;
                                      if (!value) {
                                        _autoLoginFlag = value;
                                      }
                                    });
                                  },
                                ),
                                Text("记住密码"),
                                Checkbox(
                                  value: _autoLoginFlag,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _autoLoginFlag = value;
                                      if (value) {
                                        _rememberPwdFlag = value;
                                      }
                                    });
                                  },
                                ),
                                Text("自动登录"),
                              ],
                            ),
                            LoginButton(
                              onPressed: login,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 初始化数据
  void initLoginData() {
    var loginModel = Store.value<LoginModel>(context);
    // 这里 和不setState效果一样.
    setState(() {
      _autoLoginFlag = loginModel.autoLoginFlag;
      _rememberPwdFlag = loginModel.rememberPwdFlag;
      _userCodeValue = loginModel.userCode;
      _passwordController.text = loginModel.pwd;
    });
    //当前勾选了自动登录
    if (_autoLoginFlag) {
      login();
    }
  }

  /// 异步加载用户列表
  void getUserList({bool initLoginDataFlag: false, reloadFlag: false}) async {
    var loginModel = Store.value<LoginModel>(context);
    List<UserEntity> thisUserList;
    if (reloadFlag || loginModel.userList.length < 1) {
      if (reloadFlag && loginModel.userList.length > 0) {
        loginModel.userList.clear();
      }
      thisUserList =
          await ApiService.getInstance().getListUser(context: context);
      if (thisUserList.length > 0) {
        loginModel.setUserList(thisUserList);
      }
    } else {
      thisUserList = loginModel.userList;
    }
    bool _loadFlag = false;
    if (_dropdownMenuItemList.length > 0) {
      _dropdownMenuItemList.clear();
      _loadFlag = true;
    }
    if (thisUserList != null && thisUserList.length > 0) {
      List<DropdownMenuItem<String>> thisDropdownMenuItemList = thisUserList
          .map((value) => DropdownMenuItem<String>(
                value: value.getShowValue(),
                child: Text(value.getShowLabel()),
              ))
          .toList();
      setState(() {
        _dropdownMenuItemList.addAll(thisDropdownMenuItemList);
      });
      if (initLoginDataFlag) {
        initLoginData();
      }
    } else {
      if (_loadFlag) {
        setState(() {});
      }
    }
  }

  //登录
  void login() async {
    if (_formKey.currentState.validate()) {
      String password = _passwordController.text;
      UserEntity userEntity = await Store.value<LoginModel>(context)
          .login(_userCodeValue, password);
      if (userEntity != null) {
        Store.value<UserModel>(context).saveUser(userEntity);
        var loginModel = Store.value<LoginModel>(context);
        if (_rememberPwdFlag || _autoLoginFlag) {
          loginModel.setUserInfo(userEntity.userName, _userCodeValue, password);
        }
        loginModel.setAutoLogin(_autoLoginFlag);
        loginModel.setRememberPwd(_rememberPwdFlag);
        //pushAndRemovePage(context, HomePage());
        RouteUtils.pushRouteNameAndRemovePage(context, RouteName.home);
        ToastUtil.show("登录成功");
      } else {
        //ToastUtil.show("登录失败");
      }
    }
  }

  String _checkUrl(String url) {
    if (ObjectUtils.isNotBlank(url)) {
      if (url.startsWith("http://") || url.startsWith("https://")) {
        return url.trim();
      }
    }
    ToastUtil.show("请输入正确的地址url:【$url】");
    return null;
  }
}

class LoginFormContainer extends StatelessWidget {
  final Widget child;

  LoginFormContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        color: Theme.of(context).cardColor.withOpacity(0.8),
        /*shadows: [
          BoxShadow(
              color: Theme.of(context).primaryColor.withAlpha(20),
              offset: Offset(1.0, 1.0),
              blurRadius: 10.0,
              spreadRadius: 3.0),
        ],*/
      ),
      child: child,
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  LoginButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    var model = Store.value<LoginModel>(context);
    return LoginButtonWidget(
      child: model.busy
          ? ButtonProgressIndicator()
          : Text(
              S.of(context).signIn,
              style: Theme.of(context)
                  .accentTextTheme
                  .title
                  .copyWith(wordSpacing: 6),
            ),
      onPressed: model.busy ? null : onPressed,
    );
  }
}

/// LoginPage 按钮样式封装
class LoginButtonWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  LoginButtonWidget(
      {this.child,
      this.onPressed,
      this.padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15)});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor.withAlpha(180);
    return Container(
        padding: padding,
        //width: double.infinity,
        child: CupertinoButton(
          padding: EdgeInsets.all(0),
          color: color,
          disabledColor: color,
          borderRadius: BorderRadius.circular(110),
          pressedOpacity: 0.5,
          child: child,
          onPressed: onPressed,
        ));
  }
}
