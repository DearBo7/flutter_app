import 'dart:async';

import 'package:flutter/material.dart';

import '../../../res/styles.dart';

typedef ShowCallback(CustomProgressLoadingState progressLoadingState);
typedef ShowProgress(ProgressLoading progressLoading);

class CustomProgressLoading extends StatefulWidget {
  final Text title;
  final String content;
  final TextStyle contentStyle;

  //当前值
  final int progress;

  //最大值
  final int max;

  //是否显示最大和当前值
  final bool showMinMax;

  final ShowCallback showCallback;

  CustomProgressLoading(
      {Key key,
      @required this.progress,
      @required this.max,
      this.showMinMax: false,
      this.title,
      this.content,
      this.contentStyle,
      this.showCallback})
      : assert(max != null && max > 0),
        assert(progress != null && progress > -1),
        super(key: key);

  @override
  CustomProgressLoadingState createState() => CustomProgressLoadingState();
}

class CustomProgressLoadingState extends State<CustomProgressLoading> {
  int _progress;
  int _max;
  String _content;
  TextStyle _contentStyle;

  ValueNotifier<int> _progressNotifier;

  //ValueNotifier<String> _contentNotifier;

  @override
  void initState() {
    super.initState();
    _content = widget.content;
    _contentStyle = widget.contentStyle == null
        ? TextStyle(color: Colors.grey, fontSize: 16)
        : widget.contentStyle;
    _progress = widget.progress;
    _max = widget.max;
    _progressNotifier = ValueNotifier<int>(_progress);
    //_contentNotifier = ValueNotifier<String>(_content);
    if (widget.showCallback != null) {
      Timer.run(() {
        widget.showCallback(this);
      });
    }
  }

  updateProgress(int progress) {
    if (progress > 0) {
      _progressNotifier.value = progress;
      _progress = progress;
    }
  }

  update({int progress, String content, TextStyle contentStyle}) {
    if (progress != null && progress > -1) {
      _progress = progress;
    }
    if (content != null) {
      _content = content;
    }
    if (contentStyle != null) {
      _contentStyle = contentStyle;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.title == null
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: widget.title,
                  ),
                ),
          _content == null
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(_content, style: _contentStyle)),
          ValueListenableBuilder(
            valueListenable: _progressNotifier,
            builder: (context, progressValue, child) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                      backgroundColor: Colors.redAccent[100],
                      value: _calculateTheValue(progressValue, _max),
                    ),
                  ),
                  Gaps.hGap4,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${_calculateThePercentage(progressValue, _max).toStringAsFixed(0)} %",
                          style: TextStyle(color: Colors.grey),
                        ),
                        widget.showMinMax
                            ? Text("$progressValue / $_max")
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Gaps.hGap20,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.title == null
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: widget.title,
                  ),
                ),
          _content == null
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(_content, style: _contentStyle)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.red),
              backgroundColor: Colors.redAccent[100],
              value: _calculateTheValue(_progress, _max),
            ),
          ),
          Gaps.hGap4,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${_calculateThePercentage(_progress, _max).toStringAsFixed(0)} %",
                  style: TextStyle(color: Colors.grey),
                ),
                widget.showMinMax
                    ? Text("$_progress / $_max")
                    : SizedBox.shrink(),
              ],
            ),
          ),
          Gaps.hGap20,
        ],
      ),
    );
  }*/

  /// 计算进度条值
  double _calculateTheValue(int progress, int max) {
    if (progress == null || max == null) {
      return 0;
    }
    if (progress >= max) {
      return 1;
    }
    return double.parse((progress / max).toStringAsFixed(2));
  }

  //计算百分比值
  double _calculateThePercentage(int progress, int max) {
    if (progress == null || max == null) {
      return 0;
    }
    if (progress >= max) {
      return 100;
    }
    return progress / max * 100;
  }
}

class ProgressLoading {
  /// 传过来的 Context
  BuildContext _context;
  BuildContext _dismissingContext;

  /// 当前是否已经显示
  bool _isShow = false;

  /// 加载框内容key-用于动态更新
  CustomProgressLoadingState _progressLoadingState;

  ProgressLoading(BuildContext context) {
    _context = context;
  }

  bool get isShow => _isShow;

  void show(int progress, int max,
      {Text title,
      String content,
      TextStyle contentStyle,
      List<Widget> actions,
      bool showMinMax: true,
      bool isBarrierDismissible: false,
      ShowProgress showProgress}) {
    if (_isShow) {
      return;
    }
    _progressLoadingState = null;
    _isShow = true;
    showDialog(
        context: _context,
        barrierDismissible: isBarrierDismissible,
        builder: (contextDialog) {
          _dismissingContext = contextDialog;
          return WillPopScope(
            onWillPop: () => Future.value(isBarrierDismissible),
            child: AlertDialog(
              contentPadding: EdgeInsets.only(),
              titlePadding: EdgeInsets.only(),
              content: CustomProgressLoading(
                progress: progress,
                max: max,
                showMinMax: showMinMax,
                title: title,
                content: content,
                contentStyle: contentStyle,
                showCallback: (progressLoadingState) {
                  _progressLoadingState = progressLoadingState;
                  if (showProgress != null) {
                    showProgress(this);
                  }
                },
              ),
              actions: actions,
            ),
          );
        });
  }

  void updateProgress(int progress) {
    if (_isShow && _progressLoadingState != null) {
      _progressLoadingState.updateProgress(progress);
    }
  }

  void update({int progress, String content, TextStyle contentStyle}) {
    if (_isShow && _progressLoadingState != null) {
      _progressLoadingState.update(
          content: content, contentStyle: contentStyle, progress: progress);
    }
  }

  void hide() {
    if (!_isShow) {
      return;
    }
    _isShow = false;
    if (_dismissingContext != null) {
      Navigator.of(_dismissingContext).pop();
    } else {
      Navigator.of(_context).pop();
    }
    if (_progressLoadingState != null) {
      _progressLoadingState = null;
    }
  }
}
