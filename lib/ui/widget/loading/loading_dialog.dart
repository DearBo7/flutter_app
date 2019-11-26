import 'dart:async';

import 'package:flutter/material.dart';

import '../custom/custom_dialog.dart';

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

class CustomizeLoadingDialog {
  // 空白区域/返回键 点击后是否消失-false
  bool _isBarrierDismissible;

  /// 传过来的 Context
  BuildContext _context;

  /// 加载框内容key-用于动态更新
  GlobalKey<DialogBodyState> _dialogBodyStateKey;

  /// Dialog是否隐藏-当前执行hide方法时,设置成true
  bool _isDialogHide = false;

  //显示时间
  int showStartTime = 0;

  //延迟时间
  Duration _delay;

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
      Duration delay,
      Widget showWidget}) {
    showStartTime = DateTime.now().millisecondsSinceEpoch;
    if (delay == null) {
      _delay = Duration(milliseconds: 0);
    } else {
      _delay = delay;
    }
    //如果当前是显示,取消之前的显示
    if (_isShow) {
      //hide();
      debugPrint("CustomizeLoadingDialog-->is show...");
      return this;
    }
    _isShow = true;
    _isDialogHide = false;
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
    _showDialog(showWidget);
    return this;
  }

  _showDialog(Widget showWidget) {
    _dialogBodyStateKey = GlobalKey<DialogBodyState>();
    _dismissingContext = null;
    try {
      showDialog(
          context: _context,
          barrierDismissible: _isBarrierDismissible,
          builder: (BuildContext context) {
            _dismissingContext = context;
            return WillPopScope(
              child: DialogTransparent(
                child: _DialogBody(
                    key: _dialogBodyStateKey,
                    isDialogHide: _isDialogHide,
                    showWidget: showWidget,
                    showWidgetColor: Theme.of(_context).accentColor),
              ),
              onWillPop: () async {
                return Future.value(_isBarrierDismissible);
              },
            );
          });
    } on Exception catch (e) {
      print("异常了.......");
    }
  }

  bool get isShow => _isShow;

  //隐藏
  Future<bool> hide() async {
    if (!_isDialogHide) {
      _isDialogHide = true;
    }
    if (_isShow && _dialogBodyStateKey != null) {
      int showEndTime = DateTime.now().millisecondsSinceEpoch - showStartTime;
      //判断是否需要延时隐藏,需要延时
      if (_delay.inMilliseconds > 0 && showEndTime < _delay.inMilliseconds) {
        int delayTime = _delay.inMilliseconds - showEndTime;
        debugPrint('CustomizeLoadingDialog--->[hide]:延迟:【$delayTime】 毫秒');
        await Future.delayed(Duration(milliseconds: delayTime));
      }
      return Future.value(_hide());
    } else {
      debugPrint('CustomizeLoadingDialog--->[hide]:$_isShow}');
      return Future.value(false);
    }
  }

  void update(
      {Text text, String contentText, bool isShowText, Widget showWidget}) {
    if (_isShow && _dialogBodyStateKey != null) {
      if (text != null) {
        _text = text;
      } else if (contentText != null) {
        _text = Text(contentText, style: TextStyle(fontSize: 14));
      }
      if (isShowText != null) {
        _isShowText = isShowText;
      }
      if (_dialogBodyStateKey.currentState != null) {
        _dialogBodyStateKey.currentState.update(showWidget: showWidget);
      }
    }
  }

  bool _hide() {
    try {
      debugPrint(
          'CustomizeLoadingDialog--->[hide]:$_isShow,_dismissingContext is null:${_dismissingContext == null}');
      _isShow = false;
      if (_dialogBodyStateKey.currentState == null) {
        return false;
      }
      if (_dismissingContext != null) {
        Navigator.of(_dismissingContext).pop();
      } else {
        Navigator.of(_context).pop();
      }
      if (_dialogBodyStateKey != null) {
        _dialogBodyStateKey = null;
      }
      debugPrint('CustomizeLoadingDialog--->[hide]:End...');
      return true;
    } catch (e) {
      debugPrint('CustomizeLoadingDialog--->[hide]:$_isShow error-->$e');
      try {
        Navigator.of(_context).pop();
        return true;
      } catch (e1) {
        debugPrint(
            'CustomizeLoadingDialog--->[hide]-Navigator.of(context).pop():$_isShow error-->$e1');
      }
    }
    return false;
  }
}

class _DialogBody extends StatefulWidget {
  //加载的动画
  final Widget showWidget;
  final Color showWidgetColor;

  //用于判断调用的dialog是否已经调用hide方法,如果已经隐藏(true),加载完成后执行Navigator.of(context).pop();
  final bool isDialogHide;

  _DialogBody(
      {Key key,
      this.showWidget,
      this.showWidgetColor: const Color(0xFF6278FF),
      this.isDialogHide: false})
      : super(key: key);

  @override
  DialogBodyState createState() => DialogBodyState();
}

class DialogBodyState extends State<_DialogBody> {
  Widget _showWidget;

  update({Widget showWidget}) {
    if (showWidget != null) {
      _showWidget = showWidget;
    }
    //没有执行initState方法时,mounted为false
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.showWidget == null) {
      _showWidget = CircularProgressIndicator(
        //Color(0xFF6278FF) Theme.of(context).accentColor
        valueColor: AlwaysStoppedAnimation(widget.showWidgetColor),
      );
    } else {
      _showWidget = widget.showWidget;
    }
    Timer.run(() {
      if (widget.isDialogHide) {
        debugPrint(
            'CustomizeLoadingDialog---->DialogBody Hide isDialogHide:${widget.isDialogHide}');
        _isShow = false;
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      //保证控件居中效果
      child: new SizedBox(
        width: 120.0,
        height: 120.0,
        child: new Container(
          decoration: ShapeDecoration(
            color: _isShowBackground
                ? Theme.of(context).brightness == Brightness.light
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
              _showWidget,
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
