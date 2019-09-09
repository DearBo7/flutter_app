import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../public_index.dart';
import '../widget/button/button_progress_indicator.dart';
import '../widget/login_field_widget.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color loginGradientStart = const Color(0xFFfbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);

  final _nameController = TextEditingController(text: "ToFineAdmin");
  final _passwordController = TextEditingController();

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          LoginTextField(
                            label: S.of(context).userName,
                            icon: Icons.person_outline,
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                          ),
                          LoginTextField(
                            controller: _passwordController,
                            label: S.of(context).password,
                            icon: Icons.lock_outline,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                          ),
                          LoginButton(_nameController, _passwordController),
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
  final nameController;
  final passwordController;

  LoginButton(this.nameController, this.passwordController);

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
              var formState = Form.of(context);
              if (formState.validate()) {
                UserEntity userEntity = await model.login(
                    nameController.text, passwordController.text);
                if (userEntity != null) {
                  Store.value<UserModel>(context).saveUser(userEntity);
                  //Navigator.of(context).pop(true);
                  pushAndRemovePage(context, HomePage());
                  Toast.show(context, "登录成功");
                } else {
                  Toast.show(context, "登录失败");
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

  LoginButtonWidget({this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor.withAlpha(180);
    return Padding(
        padding: const EdgeInsets.fromLTRB(15, 40, 15, 20),
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
