import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../public_index.dart';
import '../../../utils/platform_utils.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBarPreferred.getPreferredSize(context),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              Store.connect<UserModel>(
                builder: (context, model, child) {
                  if (model.hasUser) {
                    return IconButton(
                      tooltip: S.of(context).logout,
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        showDialog(
                            context: context,
                            //弹出框外不能取消
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("提示"),
                                content: Text("是否退出登录?"),
                                actions: <Widget>[
                                  //操作按钮数组
                                  FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('取消'),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Store.value<UserModel>(context)
                                          .clearUser();
                                      Store.value<LoginModel>(context)
                                          .setAutoLogin(false);
                                      RouteUtils.pushRouteNameAndRemovePage(
                                          context, RouteName.login);
                                    },
                                    child: Text('确定'),
                                  ),
                                ],
                              );
                            });
                      },
                    );
                  }
                  return SizedBox.shrink();
                },
              )
            ],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: 220,
            //高度
            flexibleSpace: UserHeaderWidget(),
            pinned: false, //滑动超出后不显示
          ),
          UserListWidget(),
        ],
      ),
    );
  }
}

/// 头部
class UserHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomClipper(),
      child: Container(
        color: Theme.of(context).primaryColor.withAlpha(200),
        child: Store.connect<UserModel>(
            builder: (context, model, child) => InkWell(
                  onTap: model.hasUser
                      ? null
                      : () {
                          Store.value<LoginModel>(context).setAutoLogin(false);
                          RouteUtils.pushRouteNameAndRemovePage(
                              context, RouteName.login);

                          /*ToastUtil.show("登录");
                          Store.value<UserModel>(context).saveUser(UserEntity(
                              id: 1, userName: "管理员", userCode: "admin"));*/
                        },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                          tag: "loginLogo",
                          child: ClipOval(
                            child: Image.asset("assets/images/user_photo.jpg",
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                                color: model.hasUser
                                    ? Theme.of(context)
                                        .accentColor
                                        .withAlpha(200)
                                    : Theme.of(context)
                                        .accentColor
                                        .withAlpha(10),
                                colorBlendMode: BlendMode.dstOver //重叠模式
                                ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        model.hasUser
                            ? model.user.userName
                            : S.of(context).noLogin,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .apply(color: Colors.white.withAlpha(200)),
                      )
                    ],
                  ),
                )),
      ),
    );
  }
}

///底部
class UserListWidget extends StatelessWidget {
  final Future<String> _futureBuilderFuture = PlatformUtils.getAppVersion();

  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).accentColor;
    return ListTileTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: SliverList(
          delegate: SliverChildListDelegate([
            ListTile(
              title: Text(S.of(context).darkMode),
              onTap: () {
                Store.value<ConfigModel>(context).switchTheme(
                    brightness: Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light);
              },
              leading: Transform.rotate(
                angle: -pi,
                child: Icon(
                  Theme.of(context).brightness == Brightness.light
                      ? Icons.brightness_2
                      : Icons.brightness_5,
                  color: iconColor,
                ),
              ),
              trailing: CupertinoSwitch(
                  activeColor: Theme.of(context).accentColor,
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    Store.value<ConfigModel>(context).switchTheme(
                        brightness: value ? Brightness.dark : Brightness.light);
                  }),
            ),
            SettingThemeWidget(),
            ListTile(
              onTap: () {
                RouteUtils.pushRouteNameNewPage(
                    context, RouteName.formulaSetting);
              },
              title: Text(S.of(context).setting),
              leading: Icon(Icons.settings, color: iconColor),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text(S.of(context).version),
              leading: Icon(Icons.error_outline, color: iconColor),
              trailing: FutureBuilder<String>(
                //异步加载
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? snapshot.data : "");
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings_backup_restore, color: iconColor),
              onTap: () => RouteUtils.pushRouteNameAndRemovePage(
                  context, RouteName.homeIndex),
              title: Text("返回主页"),
            ),
          ]),
        ));
  }
}

/// 设置主题
class SettingThemeWidget extends StatelessWidget {
  //SettingThemeWidget();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(S.of(context).theme),
      leading: Icon(
        Icons.color_lens,
        color: Theme.of(context).accentColor,
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: <Widget>[
              ...Colors.primaries.map((color) {
                return Material(
                  color: color,
                  child: InkWell(
                    onTap: () {
                      Store.value<ConfigModel>(context).switchTheme(
                          brightness: Theme.of(context).brightness,
                          themeColor: color);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                    ),
                  ),
                );
              }).toList(),
              Material(
                child: InkWell(
                  onTap: () {
                    Store.value<ConfigModel>(context).switchRandomTheme(
                        brightness: Theme.of(context).brightness);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).accentColor)),
                    width: 40,
                    height: 40,
                    child: Text(
                      "?",
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).accentColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

///剪切背景
class BottomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    int _height = 50;
    path.lineTo(0, 0);
    path.lineTo(0, size.height - _height);

    var p1 = Offset(size.width / 2, size.height);
    var p2 = Offset(size.width, size.height - _height);
    path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    path.lineTo(size.width, size.height - _height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
