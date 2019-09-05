import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../public_index.dart';
import '../../utils/platform_utils.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  PackageInfo _packageInfo;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBarPreferred.getPreferredSize(context),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              Store.connect<UserModel>(
                  builder: (context, model, child) => Offstage(
                        offstage: !model.hasUser,
                        child: IconButton(
                          tooltip: FlutterI18n.translate(context, 'logout'),
                          icon: Icon(Icons.exit_to_app),
                          onPressed: () {
                            //退出登录
                            Toast.show(context, "退出登录");
                            Store.value<UserModel>(context).clearUser();
                          },
                        ),
                      ))
            ],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: 220, //高度
            flexibleSpace: UserHeaderWidget(),
            pinned: false, //滑动超出后不显示
          ),
          UserListWidget(),
        ],
      ),
    );
  }

  void initData() async {
    _packageInfo = await PackageInfo.fromPlatform();
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
                          Toast.show(context, "登录");
                          Store.value<UserModel>(context).saveUser(UserEntity(
                              id: 1, userName: "管理员", userCode: "admin"));
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
                            : FlutterI18n.translate(context, 'noLogin'),
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
  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).accentColor;
    return ListTileTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: SliverList(
          delegate: SliverChildListDelegate([
            ListTile(
              onTap: () {
                Toast.show(context, "设置");
              },
              title: Text("设置"),
              leading: Icon(Icons.settings, color: iconColor),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("版本号"),
              leading: Icon(Icons.error_outline, color: iconColor),
              trailing: FutureBuilder<String>(//异步加载
                future: PlatformUtils.getAppVersion(),
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? snapshot.data : "");
                },
              ),
            ),
          ]),
        ));
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
