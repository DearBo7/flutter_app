import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../public_index.dart';
import '../widget/button/button_progress_indicator.dart';
import '../widget/login_field_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color loginGradientStart = const Color(0xFFfbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);

  // 上次点击时间
  DateTime _lastPressedAt;

  // 用户账号列表
  List<DropdownMenuItem<String>> dropdownMenuItemList = [];

  // 密码
  TextEditingController _passwordController = TextEditingController();

  // 用户code
  String _userCodeValue;

  // 自动登录
  bool _autoLoginFlag = false;

  // 记住密码
  bool _rememberPwdFlag = false;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      initData();

      /// 加载用户信息
      getUserList();
    });
  }

  /// 初始化数据
  void initData() {
    var loginModel = Store.value<LoginModel>(context);
    // 这里 和不setState效果一样.
    setState(() {
      _autoLoginFlag = loginModel.autoLoginFlag;
      _rememberPwdFlag = loginModel.rememberPwdFlag;
      _userCodeValue = loginModel.userCode;
      _passwordController.text = loginModel.pwd;
    });
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
                //border: Border.all(color: Colors.amber),
                gradient: LinearGradient(
                  colors: const [loginGradientStart, loginGradientEnd],
                  stops: const [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50),

                  /// login图片
                  LoginLogo(),
                  //登录输入框
                  LoginFormContainer(
                    child: Form(
                      //在请求的时候,阻止点击返回
                      onWillPop: () async {
                        //如果不是在请求时,判断是否返回两次
                        if (!Store.value<LoginModel>(context).busy) {
                          if (_lastPressedAt == null ||
                              DateTime.now().difference(_lastPressedAt) >
                                  Duration(seconds: 1)) {
                            //两次点击间隔超过1秒则重新计时
                            _lastPressedAt = DateTime.now();
                            Toast.show(context, "再按一次退出");
                            return false;
                          }
                          return true;
                        }
                        return false;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline,
                                    color: Theme.of(context).accentColor,
                                    size: 20),
                                //hintStyle: TextStyle(fontSize: 14),
                              ).applyDefaults(
                                  Theme.of(context).inputDecorationTheme),
                              //无匹配显示
                              hint: Text(dropdownMenuItemList.isEmpty
                                  ? "暂无账号信息"
                                  : "请选择账号"),
                              items: dropdownMenuItemList,
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
                                    ? "请选择用户"
                                    : null;
                              },
                            ),
                          ),

                          /*LoginTextField(
                            label: S.of(context).userName,
                            icon: Icons.person_outline,
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                          ),*/
                          LoginTextField(
                            controller: _passwordController,
                            label: S.of(context).password,
                            icon: Icons.lock_outline,
                            obscureText: true,
                            maxLength: 16,
                            textInputAction: TextInputAction.done,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
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
                          ),
                          LoginButton(_userCodeValue, _passwordController.text,
                              autoLoginFlag: _autoLoginFlag,
                              rememberPwdFlag: _rememberPwdFlag),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 异步加载用户列表
  void getUserList() async {
    var loginModel = Store.value<LoginModel>(context);
    List<UserEntity> thisUserList;
    if (loginModel.userList.length > 0) {
      thisUserList = loginModel.userList;
    } else {
      thisUserList =
          await ApiService.getInstance().getListUser(context: context);
      if (thisUserList.length > 0) {
        loginModel.setUserList(thisUserList);
      } else {
        return;
      }
    }
    List<DropdownMenuItem<String>> thisDropdownMenuItemList = thisUserList
        .map(
          (value) => DropdownMenuItem<String>(
            value: value.getShowValue(),
            child: Text(value.getShowLabel()),
          ),
        )
        .toList();
    setState(() {
      dropdownMenuItemList.addAll(thisDropdownMenuItemList);
    });
  }
}

class LoginLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Hero(
      tag: "login Logo",
      child: Image.asset(
        "assets/images/login_logo.png",
        height: 200,
        width: 250,
        fit: BoxFit.fitWidth,
        /*color: theme.brightness == Brightness.dark
            ? theme.accentColor
            : Colors.white,
        colorBlendMode: BlendMode.srcIn,*/
      ),
    );
  }
}

class LoginFormContainer extends StatelessWidget {
  final Widget child;

  LoginFormContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        color: Theme.of(context).cardColor,
        shadows: [
          BoxShadow(
              color: Theme.of(context).primaryColor.withAlpha(20),
              offset: Offset(1.0, 1.0),
              blurRadius: 10.0,
              spreadRadius: 3.0),
        ],
      ),
      child: child,
    );
  }
}

class LoginButton extends StatelessWidget {
  final String userCode;
  final String password;

  // 自动登录
  final bool autoLoginFlag;

  // 记住密码
  final bool rememberPwdFlag;

  LoginButton(this.userCode, this.password,
      {this.autoLoginFlag: false, this.rememberPwdFlag: false});

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
      onPressed: model.busy
          ? null
          : () async {
              if (Form.of(context).validate()) {
                UserEntity userEntity = await model.login(userCode, password);
                if (userEntity != null) {
                  Store.value<UserModel>(context).saveUser(userEntity);
                  var loginModel = Store.value<LoginModel>(context);
                  if (rememberPwdFlag || autoLoginFlag) {
                    loginModel.setUserInfo(
                        userEntity.userName, userCode, password);
                  }
                  loginModel.setAutoLogin(autoLoginFlag);
                  loginModel.setRememberPwd(rememberPwdFlag);
                  //pushAndRemovePage(context, HomePage());
                  RouteUtils.pushRouteNameAndRemovePage(
                      context, RouteName.homePage);
                  Toast.show(context, "登录成功");
                } else {
                  //Toast.show(context, "登录失败");
                }
              }
            },
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
    return Padding(
        padding: padding,
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
