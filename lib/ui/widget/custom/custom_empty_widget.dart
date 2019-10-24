import 'package:flutter/material.dart';

import '../../../generated/i18n.dart';

class CustomListEmptyWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  /// 是否显示图片
  final bool showImage;

  final String emptyText;

  final String emptyImgUrl;

  final double imgWidth;
  final double imgHeight;

  final TextStyle textStyle;

  CustomListEmptyWidget(
      {Key key,
      this.emptyImgUrl: "assets/images/empty.png",
      this.showImage: true,
      this.onRefresh,
      this.emptyText,
      this.imgWidth = 160,
      this.imgHeight = 150,
      this.textStyle: const TextStyle(fontSize: 18.0, color: Colors.grey)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showImage
              ? Image.asset(emptyImgUrl, width: imgWidth, height: imgHeight)
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                emptyText ?? S.of(context).noData,
                style: textStyle,
              ),
              onRefresh == null
                  ? SizedBox.shrink()
                  : _refreshWidget(context, onRefresh),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomTextEmptyWidget extends StatelessWidget {
  final String emptyText;

  final TextStyle textStyle;

  CustomTextEmptyWidget(
      {Key key,
      this.emptyText,
      this.textStyle: const TextStyle(fontSize: 18.0, color: Colors.grey)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      emptyText ?? S.of(context).noData,
      style: textStyle,
      textAlign: TextAlign.center,
    );
  }
}

Widget _refreshWidget(BuildContext context, VoidCallback onRefresh) {
  return Tooltip(
    message: S.of(context).refresh,
    child: IconButton(
        icon: Icon(
          Icons.refresh,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
        onPressed: onRefresh),
  );
}
