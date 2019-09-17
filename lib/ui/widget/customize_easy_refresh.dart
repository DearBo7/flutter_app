import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../generated/i18n.dart';

class CustomizeEasyRefresh {
  //下拉刷新列表首次加载组件
  static Widget defaultFirstRefreshWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
          child: SizedBox(
        height: 200.0,
        width: 300.0,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                child: SpinKitFadingCube(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              ),
              Container(
                child: Text(S.of(context).loading),
              )
            ],
          ),
        ),
      )),
    );
  }

  static ClassicalHeader defaultClassicalHeader(BuildContext context) {
    return ClassicalHeader(
      enableHapticFeedback: true,
      //开启震动反馈,
      float: true,
      //是否浮动
      refreshText: S.of(context).pullToRefresh,
      refreshReadyText: S.of(context).releaseToRefresh,
      refreshingText: S.of(context).refreshing,
      refreshedText: S.of(context).refreshed,
      refreshFailedText: S.of(context).refreshFailed,
      noMoreText: S.of(context).noMore,
      infoText: S.of(context).updateAt,
      textColor: Colors.white,
      bgColor: Colors.black87,
      infoColor: Colors.white70,
    );
  }
}
