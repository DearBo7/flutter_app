import 'dart:async';

import 'package:flutter/material.dart';

/// 当前是否已经显示
bool _isShow = false;

/// 弹出框的 Context
BuildContext _dismissingContext;

/// 显示的文字内容
Text _text;

/// 是否显示文字
bool _isShowText;

// 显示背景-true
bool _isShowBackground;

//延迟显示dialog,如果为true,即将显示dialog
bool _delayDialogFlag = false;

class CustomizeLoadingDialog {
  // 空白区域/返回键 点击后是否消失-false
  bool _isBarrierDismissible;

  /// 传过来的 Context
  BuildContext _context;

  _DialogBody _dialogBody;

  CustomizeLoadingDialog(BuildContext context,
      {bool isShowBackground: true, bool isBarrierDismissible: false}) {
    this._context = context;
    _isShowBackground = isShowBackground;
    this._isBarrierDismissible = isBarrierDismissible;
  }

  CustomizeLoadingDialog showText({Text text, String contentText}) {
    return show(text: text, contentText: contentText, isShowText: true);
  }

  /// 显示
  CustomizeLoadingDialog show(
      {Text text,
      String contentText,
      bool isShowText: false,
      Duration delay: const Duration(milliseconds: 0)}) {
    //如果当前是显示,取消之前的显示
    if (_isShow) {
      //hide();
      debugPrint("CustomizeLoadingDialog-->is show...");
      return this;
    }
    _isShow = true;
    _isShowText = isShowText;
    if (isShowText) {
      if (text == null) {
        _text = Text(
          contentText ?? "加载中...",
          style: TextStyle(fontSize: 14),
        );
      } else {
        _text = text;
      }
    }
    _delayDialogFlag = false;
    //延迟100毫秒,预计250毫秒才会加载动画
    Timer(delay, () {
      if (!_isShow) {
        debugPrint("CustomizeLoadingDialog-->show()--end...");
        return;
      }
      _delayDialogFlag = true;
      debugPrint("CustomizeLoadingDialog-->show()--showDialog...");
      showDialog<dynamic>(
          context: _context, //BuildContext对象
          barrierDismissible: _isBarrierDismissible,
          builder: (BuildContext context) {
            if (_isShow) {
              _dismissingContext = context;
            }
            return WillPopScope(
              child: LoadingDialog(child: _dialogBody = _DialogBody()),
              onWillPop: () async {
                return Future.value(_isBarrierDismissible && _isShow);
              },
            );
          });
    });
    return this;
  }

  bool isShowing() {
    return _isShow;
  }

  //隐藏
  void hide() {
    if (_isShow) {
      try {
        debugPrint(
            'CustomizeLoadingDialog--->[hide]:$_isShow,_dismissingContext is null:${_dismissingContext == null}');
        _isShow = false;
        if (_dismissingContext != null) {
          Navigator.of(_dismissingContext).pop();
          _dismissingContext = null;
        } else if (_delayDialogFlag) {
          Navigator.of(_context).pop();
        }
        if (_dialogBody != null) {
          _dialogBody = null;
        }
      } catch (_) {
        debugPrint('CustomizeLoadingDialog--->[hide]:$_isShow error-->$_');
      }
    } else {
      debugPrint('CustomizeLoadingDialog--->[hide]:$_isShow}');
    }
  }
}

class _DialogBody extends StatefulWidget {
  final _DialogBodyState _dialogBodyState = _DialogBodyState();

  update() {
    _dialogBodyState.update();
  }

  @override
  _DialogBodyState createState() => _dialogBodyState;
}

class _DialogBodyState extends State<_DialogBody> {
  update() {
    setState(() {});
  }

  @override
  void dispose() {
    if (_isShow) {
      _isShow = false;
      debugPrint('CustomizeLoadingDialog--> _DialogBody dispose...');
      //判断当前页面能否进行pop操作，并返回bool值
      try {
        if (Navigator.of(_dismissingContext).canPop()) {
          Navigator.of(_dismissingContext).pop();
        }
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Center(
      //保证控件居中效果
      child: new SizedBox(
        width: 120.0,
        height: 120.0,
        child: new Container(
          decoration: ShapeDecoration(
            color: _isShowBackground
                ? theme.brightness == Brightness.light
                    ? Color(0xffffffff)
                    : Colors.black38
                : Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(
                //Color(0xFF6278FF)
                valueColor: AlwaysStoppedAnimation(theme.accentColor),
              ),
              !_isShowText
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: _text,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingDialog extends Dialog {
  final Widget child;

  LoadingDialog({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: child,
    );
  }
}
