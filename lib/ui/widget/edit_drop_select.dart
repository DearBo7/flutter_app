import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Widget AutoCompleteOverlayItemBuilder<T>(
    BuildContext context, T suggestion);
//筛选条件
typedef bool Filter<T>(T suggestion, String query);

typedef InputEventCallback<T>(T data);

typedef StringCallback(String data);

//获取显示的value
typedef String GetShowValue<T>(T data);

class AutoSelectTextField<T> extends StatefulWidget {
  //数据源
  final List<T> items;

  //下拉列表最大显示条数
  final int maxCount;

  //条目输入最小长度才开始匹配-如果最小为0,值为null/""空时显示maxCount条
  final int minLength;

  //筛选匹配条件
  final Filter<T> itemFilter;

  //排序
  final Comparator<T> itemSorter;
  final StringCallback textChanged, textSubmitted;
  final GetShowValue<T> itemShowValue;

  //文本框聚焦
  final ValueSetter<bool> onFocusChanged;

  //点击下拉条目提交触发
  final InputEventCallback<T> itemSubmitted;

  //加载 build
  final AutoCompleteOverlayItemBuilder<T> itemBuilder;

  final bool submitOnSuggestionTap, clearOnSubmit;
  final List<TextInputFormatter> inputFormatters;

  final TextStyle style;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final FocusNode focusNode;

  //是否禁用输入-默认true,不禁用
  final bool enabled;

  //是否禁用下拉-默认true,不禁用
  final bool enabledDrop;

  //内容边距
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry padding;

  //下拉框展开最大高度:100
  final double downHeight;

  //弹出框是否筛选,如果不筛选,下拉列表显示最大条数
  final bool filterFlag;

  AutoSelectTextField(
      {GlobalKey<AutoSelectTextFieldState<T>> key,
      this.items,
      this.itemBuilder,
      this.itemFilter,
      this.itemSorter,
      this.itemSubmitted,
      this.downHeight: 100,
      this.maxCount,
      this.minLength: 1,
      this.textChanged,
      this.textSubmitted,
      this.onFocusChanged,
      this.submitOnSuggestionTap: true,
      this.clearOnSubmit: true,
      this.inputFormatters,
      this.itemShowValue,
      this.style,
      this.keyboardType: TextInputType.text,
      this.textInputAction: TextInputAction.done,
      this.textCapitalization: TextCapitalization.none,
      this.enabled: true,
      this.enabledDrop: true,
      this.controller,
      this.focusNode,
      this.contentPadding: const EdgeInsets.all(8.0),
      this.padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      this.filterFlag: true})
      : assert(downHeight != null && downHeight > -1),
        super(key: key);

/*  //添加单条
  void add(T item) => _autoSelectTextFieldState.add(item);

  //添加多条
  void addAll(List<T> dataList) => _autoSelectTextFieldState.addAll(dataList);

  //删除
  void remove(T suggestion) => _autoSelectTextFieldState.remove(suggestion);

  //根据下标删除
  void removeAt(int index) => _autoSelectTextFieldState.removeAt(index);

  //重新设置下拉框数据源,并且清空之前的
  void setItems(List<T> dataList) =>
      _autoSelectTextFieldState.setItems(dataList);

  //清空当前输入的值,解除聚焦
  void clearValue() => _autoSelectTextFieldState.clearValue();

  //清空下拉框数据源
  void clearItems() => _autoSelectTextFieldState.clearItems();*/

  final AutoSelectTextFieldState<T> _autoSelectTextFieldState =
      AutoSelectTextFieldState();

  @override
  AutoSelectTextFieldState createState() => _autoSelectTextFieldState;
}

class AutoSelectTextFieldState<T> extends State<AutoSelectTextField> {
  final LayerLink _layerLink = LayerLink();
  TextField _textField;

  //当前新值
  String _currentText = "";
  TextEditingController _controller;

  //过滤后的数据
  List<T> _filterItems;

  OverlayEntry _overlayEntryItems;
  Filter<T> _itemFilter;
  GetShowValue<T> _itemShowValue;
  AutoCompleteOverlayItemBuilder<T> _itemBuilder;

  bool _clearOnSubmit;
  bool _submitOnSuggestionTap;

  //是否聚焦
  bool _hasFocusFlag = false;

  //是否筛选,如果不筛选,下拉列表显示最大条数
  bool _filterFlag;

  void _init() {
    _filterFlag = widget.filterFlag ?? true;
    _submitOnSuggestionTap = widget.submitOnSuggestionTap ?? true;
    _clearOnSubmit = widget.clearOnSubmit ?? true;
    //默认获取显示的value
    if (widget.itemShowValue == null) {
      _itemShowValue = (t) => t.toString();
    } else {
      _itemShowValue = widget.itemShowValue;
    }
    //默认条目构造方法
    if (widget.itemBuilder == null) {
      _itemBuilder = (context, item) {
        return Padding(
            padding: widget.contentPadding,
            child: new Text(_itemShowValue(item)));
      };
    } else {
      _itemBuilder = widget.itemBuilder;
    }
    //默认过滤器
    if (widget.itemFilter == null) {
      _itemFilter = (item, query) =>
          _itemShowValue(item).toLowerCase().startsWith(query.toLowerCase());
    } else {
      _itemFilter = widget.itemFilter;
    }

    _textField = TextField(
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      decoration: null,
      enabled: widget.enabled,
      style: widget.style,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode ?? FocusNode(),
      controller: widget.controller ?? TextEditingController(),
      textInputAction: widget.textInputAction,
      //输入文本发生变化时的回调
      onChanged: (newText) {
        _currentText = newText;
        updateOverlayValue(newText);
        if (widget.textChanged != null) {
          widget.textChanged(newText);
        }
      },
      //点击输入框时的回调(){}
      onTap: () {
        //updateOverlay(currentText);
      },
      //同样是点击键盘完成按钮时触发的回调，该回调有参数，参数即为当前输入框中的值。(String){}
      onSubmitted: (submittedText) {
        //triggerSubmitted(submittedText: submittedText)
        return submittedText;
      },
    );

    if (this._controller != null && this._controller.text != null) {
      _currentText = this._controller.text;
    }

    //监听聚焦事件
    _textField.focusNode.addListener(() {
      if (widget.onFocusChanged != null) {
        widget.onFocusChanged(_textField.focusNode.hasFocus);
      }
      setState(() {
        _hasFocusFlag = _textField.focusNode.hasFocus;
      });
      //文本框聚焦
      if (_textField.focusNode.hasFocus) {
        updateOverlayValue(_currentText);
      } else {
        _clearOverlay();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //print("AutoSelectTextFieldState===========initState");
    _init();
  }

  @override
  Widget build(BuildContext context) {
    //print("AutoSelectTextFieldState===========build");
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _hasFocusFlag || !widget.enabledDrop
            ? null
            : () {
                //获取焦点
                FocusScope.of(context).requestFocus(_textField.focusNode);
              },
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: !widget.enabledDrop ? Colors.grey[300] : null,
            border: Border.all(
                color: _hasFocusFlag ? Colors.blue : Colors.grey[400]),
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(child: _textField),
              InkWell(
                onTap: !_hasFocusFlag ? null : () => _clearOverlay(),
                child: Icon(
                    _hasFocusFlag ? Icons.arrow_drop_down : Icons.arrow_left),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _textField.focusNode.dispose();
    }
    if (widget.controller == null) {
      _textField.controller.dispose();
    }
    if (_overlayEntryItems != null) {
      _overlayEntryItems.remove();
      // ignore: unnecessary_statements
      _overlayEntryItems == null;
    }
    super.dispose();
  }

  void updateOverlayValue([String query]) {
    if (_overlayEntryItems == null) {
      final Size textFieldSize = (context.findRenderObject() as RenderBox).size;
      final width = textFieldSize.width;
      final height = textFieldSize.height;
      _overlayEntryItems = OverlayEntry(builder: (context) {
        return Positioned(
          width: width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, height),
            child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Material(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Container(
                  constraints: BoxConstraints(maxHeight: widget.downHeight),
                  child: SingleChildScrollView(
                    child: Column(
                      children: _filterItems.map((item) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (_submitOnSuggestionTap) {
                                      String showValue = _itemShowValue(item);
                                      _textField.controller.text = showValue;
                                      _currentText = showValue;
                                      _textField.focusNode.unfocus();
                                      if (widget.itemSubmitted != null) {
                                        widget.itemSubmitted(item);
                                      }
                                      if (_clearOnSubmit) {
                                        _clearOverlay();
                                      }
                                    } else {
                                      String showValue = _itemShowValue(item);
                                      _textField.controller.text = showValue;
                                      _currentText = showValue;
                                      if (widget.textChanged != null) {
                                        widget.textChanged(showValue);
                                      }
                                    }
                                  });
                                },
                                child: _itemBuilder(context, item),
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => Overlay.of(context).insert(_overlayEntryItems));
    }
    _filterItems = _getFilterData(widget.items, widget.itemSorter, _itemFilter,
        widget.maxCount, query, _filterFlag);
    _overlayEntryItems.markNeedsBuild();
  }

  //清空弹出的,然后结束聚焦
  void _clearOverlay() {
    if (_overlayEntryItems != null) {
      _filterItems = [];
      _overlayEntryItems.markNeedsBuild();
    }
    if (_textField.focusNode.hasFocus) {
      _textField.focusNode.unfocus();
    }
  }

  //获取过滤后的数据
  List<T> _getFilterData(List<T> suggestions, Comparator<T> sorter,
      Filter<T> filter, int maxAmount, String query, bool filterFlag) {
    if (null == query) {
      return [];
    }
    if (widget.minLength > 0 && query.length < widget.minLength) {
      return [];
    }
    if (query.isNotEmpty && filterFlag) {
      suggestions = suggestions.where((item) => filter(item, query)).toList();
    }
    if (sorter != null) {
      suggestions.sort(sorter);
    }
    if (maxAmount != null && maxAmount > 0 && suggestions.length > maxAmount) {
      suggestions = suggestions.sublist(0, maxAmount);
    }
    return suggestions;
  }

  //清空值和当前下拉数据
  void clearAll() {
    clearItems();
    clearValue();
  }

  /// 动态添加数据,修改,删除,清空当前value
  void clearValue() {
    _textField.controller.clear();
    _currentText = "";
    if (_textField.focusNode.hasFocus) {
      _textField.focusNode.unfocus();
    }
  }

  /// 动态清空下拉条目
  void clearItems() {
    if (widget.items.length > 0) {
      widget.items.clear();
    }
    _clearOverlay();
  }

  void add(T item) {
    widget.items.add(item);
    updateOverlayValue(_currentText);
  }

  void addAll(List<T> dataList) {
    this.widget.items.addAll(dataList);
    updateOverlayValue(_currentText);
  }

  bool remove(T item) {
    bool flag = false;
    if (widget.items.contains(item)) {
      flag = widget.items.remove(item);
    }
    updateOverlayValue(_currentText);
    return flag;
  }

  T removeAt(int index) {
    if (index != null && index > -1 && index < widget.items.length) {
      return widget.items.removeAt(index);
    }
    return null;
  }

  void setItems(List<T> dataList) {
    if (widget.items.length > 0) {
      widget.items.clear();
    }
    if (dataList != null && dataList.length > 0) {
      widget.items.addAll(dataList);
    }
    updateOverlayValue(_currentText);
  }
}
