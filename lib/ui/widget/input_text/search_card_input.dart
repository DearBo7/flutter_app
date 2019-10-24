import 'package:flutter/material.dart';
import '../../../utils/object_utils.dart';

class SearchCardInput extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final bool isShowLeading;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final bool autoFocus;
  final bool isShowSuffixIcon;
  final double elevation;
  final String searchText;

  SearchCardInput(
      {Key key,
      this.focusNode,
      this.controller,
      this.isShowLeading: true,
      this.hintText,
      this.onSubmitted,
      this.onChanged,
      this.autoFocus: false,
      this.isShowSuffixIcon: true,
      this.elevation: 2.0,
      this.searchText})
      : super(key: key);

  @override
  _SearchCardInputState createState() => _SearchCardInputState();
}

class _SearchCardInputState extends State<SearchCardInput> {
  TextEditingController _textEditingController;
  String _hintText;
  FocusNode _focusNode;
  bool _clearButtonShow;

  void _init() {
    _textEditingController =
        widget.controller ?? TextEditingController(text: widget.searchText);
    _focusNode = widget.focusNode ?? FocusNode();
    _clearButtonShow =
        widget.isShowSuffixIcon && ObjectUtils.isNotBlank(widget.searchText);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    _hintText = widget.hintText;
    return searchCard();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _textEditingController.dispose();
    }
    super.dispose();
  }

  Widget searchCard() {
    List<Widget> widgets = [];
    if (widget.isShowLeading) {
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 5, top: 0, left: 5),
        child: Icon(
          Icons.search,
          color: Colors.grey,
          size: 20,
        ),
      ));
    }

    Widget content = Expanded(
      child: Container(
          height: 34,
          child: TextField(
            autofocus: widget.autoFocus,
            focusNode: _focusNode,
            style: TextStyle(fontSize: 14),
            controller: _textEditingController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 8),
              border: InputBorder.none,
              hintText: _hintText,
              suffixIcon: !_clearButtonShow
                  ? SizedBox()
                  : Container(
                      width: 20.0,
                      height: 20.0,
                      alignment: Alignment.centerRight,
                      child: new IconButton(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 6),
                        iconSize: 18.0,
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey[500],
                          size: 16,
                        ),
                        onPressed: () => setState(() {
                          _clearButtonShow = false;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _textEditingController.clear();
                            if (widget.onChanged != null) {
                              widget.onChanged(_textEditingController.text);
                            }
                            _focusNode.unfocus();
                          });
                        }),
                      ),
                    ),
            ),
            onSubmitted: widget.onSubmitted,
            onChanged: (value) {
              if (widget.isShowSuffixIcon) {
                if (_clearButtonShow != ObjectUtils.isNotBlank(value)) {
                  setState(() {
                    _clearButtonShow = !_clearButtonShow;
                  });
                }
              }
              if (widget.onChanged != null) {
                widget.onChanged(value);
              }
            },
          )),
    );
    widgets.add(content);
    return Container(
      child: Card(
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))), //设置圆角
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets,
        ),
      ),
    );
  }
}
