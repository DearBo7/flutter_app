import 'package:flutter/material.dart';

import '../../../public_index.dart';
import '../custom/custom_empty_widget.dart';

//获取显示的value
typedef String GetShowValue<T>(T data);
typedef void OnItemSelected<T>(T item, int valueIndex, int keyIndex);

class DropDownMenu<T> extends StatefulWidget {
  final Map<String, List<T>> mapItems;
  final GetShowValue<T> itemShowText;
  final OnItemSelected<T> onItemSelected;
  final int defaultKeyIndex;
  final int defaultValueIndex;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry valuePadding;

  //刷新
  final VoidCallback onRefresh;

  //列表最大高度->最好是 itemHeight 的倍数
  final double maxHeight;

  //key 宽度
  final double keyWidth;

  //条目高度
  final double itemHeight;

  //选中的字体颜色
  final Color checkFontColor;

  //是否搜索
  //final bool searchValue;

  DropDownMenu(
      {Key key,
      this.mapItems,
      this.itemShowText,
      this.defaultKeyIndex: -1,
      this.defaultValueIndex: -1,
      this.onItemSelected,
      this.margin,
      this.padding,
      this.maxHeight: 320.0,
      this.keyWidth: 60.0,
      this.itemHeight: 40.0,
      this.valuePadding: const EdgeInsets.symmetric(horizontal: 5),
      this.checkFontColor,
      //this.searchValue: false,
      this.onRefresh})
      : assert(defaultKeyIndex != null && defaultValueIndex != null),
        assert(maxHeight != null && keyWidth != null && itemHeight != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => DropDownMenuState<T>();
}

class DropDownMenuState<T> extends State<DropDownMenu<T>> {
  Map<String, List<T>> _mapItems;
  final List<String> _keyFirstLevelList = [];
  final List<T> _valueSecondLevelList = [];

  //过滤后的数据
  //List<T> _valueFilterList= [];
  GetShowValue<T> _itemShowText;
  Color _checkFontColor;
  int _selectTempFirstLevelIndex = -1;
  int _selectFirstLevelIndex = -1;
  int _selectSecondLevelIndex = -1;
  int _defaultKeyIndex;
  int _defaultValueIndex;
  TextEditingController _searchTextController;

  _init() {
    _checkFontColor = widget.checkFontColor;
    /*if(widget.searchValue){
      _searchTextController = TextEditingController();
    }*/
    //获取右边值显示的value
    if (widget.itemShowText == null) {
      _itemShowText = (t) => t.toString();
    } else {
      _itemShowText = widget.itemShowText;
    }
    if (widget.mapItems == null || widget.mapItems.length < 1) {
      _mapItems = {};
    } else {
      _mapItems = widget.mapItems;
      _keyFirstLevelList.addAll(_mapItems.keys.toList());
    }
    _defaultKeyIndex = widget.defaultKeyIndex;
    _defaultValueIndex = widget.defaultValueIndex;
    _setSelectIndex();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkFontColor == null || !ColorUtils.getThemeLight(context)) {
      _checkFontColor = ColorUtils.getThemeLight(context)
          ? Theme.of(context).primaryColor
          : Colors.black;
    }
    return Container(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      margin: widget.margin,
      child: Material(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Column(
          children: <Widget>[
            /*widget.searchValue
                ? Container(
              child: SearchCardInput(
                onChanged: (value){

                },
              ),
            )
                : SizedBox.shrink(),*/
            Expanded(
              child: _mapItems.isEmpty
                  ? Container(
                      child: CustomListEmptyWidget(
                        onRefresh: widget.onRefresh,
                      ),
                    )
                  : Container(
                      padding: widget.padding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: widget.keyWidth,
                            child: ListView.builder(
                              padding: EdgeInsets.only(),
                              itemCount: _keyFirstLevelList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var itemKey = _keyFirstLevelList[index];
                                return GestureDetector(
                                  onTap: () {
                                    //第一级条目点击
                                    setState(() {
                                      _selectTempFirstLevelIndex = index;
                                      if (_valueSecondLevelList.length > 0) {
                                        _valueSecondLevelList.clear();
                                      }
                                      _valueSecondLevelList
                                          .addAll(_mapItems[itemKey]);
                                    });
                                  },
                                  child: Container(
                                    height: widget.itemHeight,
                                    color: _getSelectColor(
                                        _selectTempFirstLevelIndex == index),
                                    alignment: Alignment.center,
                                    child: _selectTempFirstLevelIndex == index
                                        ? Text(itemKey,
                                            style: TextStyle(
                                              color: _checkFontColor,
                                            ))
                                        : Text(itemKey),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: _getSelectColor(true),
                              child: _valueSecondLevelList.isEmpty
                                  ? SizedBox.shrink()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(),
                                      itemCount: _valueSecondLevelList.length,
                                      itemBuilder: (context, index) {
                                        T item = _valueSecondLevelList[index];
                                        return InkWell(
                                          onTap: () {
                                            //第二级条目点击
                                            _selectSecondLevelIndex = index;
                                            _selectFirstLevelIndex =
                                                _selectTempFirstLevelIndex;
                                            if (widget.onItemSelected != null) {
                                              widget.onItemSelected(item, index,
                                                  _selectFirstLevelIndex);
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: widget.itemHeight,
                                            padding: widget.valuePadding,
                                            alignment: Alignment.centerLeft,
                                            child: _selectFirstLevelIndex ==
                                                        _selectTempFirstLevelIndex &&
                                                    _selectSecondLevelIndex ==
                                                        index
                                                ? Text(
                                                    _itemShowText(item),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: _checkFontColor),
                                                  )
                                                : Text(_itemShowText(item),
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color _getSelectColor(bool selectFlag) {
    if (selectFlag) {
      return ColorUtils.getThemeModeColor(context,
          light: Colors.grey[200], dark: Colors.black12);
    } else {
      return ColorUtils.getThemeModeColor(context,
          light: Colors.white, dark: Colors.black.withOpacity(0.25));
    }
  }

  //设置数据,并且选中下标
  void _setItems(Map<String, List<T>> mapItems, int defaultKeyIndex,
      int defaultValueIndex) {
    if (defaultKeyIndex != null) {
      _defaultKeyIndex = defaultKeyIndex;
    }
    if (defaultValueIndex != null) {
      _defaultValueIndex = defaultValueIndex;
    }
    _mapItems.addAll(mapItems);
    if (_keyFirstLevelList.isNotEmpty) {
      _keyFirstLevelList.clear();
    }
    _keyFirstLevelList.addAll(_mapItems.keys.toList());
    if (_valueSecondLevelList.isNotEmpty) {
      _valueSecondLevelList.clear();
    }
    _setSelectIndex();
  }

  //选择下标,_mapItems不能为空
  void _setSelectIndex() {
    if (_mapItems.isNotEmpty) {
      if (_defaultKeyIndex > -1 &&
          _defaultKeyIndex < _keyFirstLevelList.length) {
        _selectTempFirstLevelIndex = _defaultKeyIndex;
        _valueSecondLevelList
            .addAll(_mapItems[_keyFirstLevelList[_selectTempFirstLevelIndex]]);
        if (_defaultValueIndex > -1 &&
            _defaultValueIndex < _valueSecondLevelList.length) {
          _selectFirstLevelIndex = _selectTempFirstLevelIndex;
          _selectSecondLevelIndex = _defaultValueIndex;
        }
      }
    }
  }

  //////////////////////公开的/////////////////////

  //清空数据
  void clean() {
    if (_mapItems.isNotEmpty) {
      _mapItems.clear();
    }
    if (_keyFirstLevelList.isNotEmpty) {
      _keyFirstLevelList.clear();
    }
    if (_valueSecondLevelList.isNotEmpty) {
      _valueSecondLevelList.clear();
    }
    _selectTempFirstLevelIndex = -1;
    _selectFirstLevelIndex = -1;
    _selectSecondLevelIndex = -1;
    setState(() {});
  }

  /// 添加数据
  void addItems(Map<String, List<T>> mapItems,
      {int defaultKeyIndex, int defaultValueIndex}) {
    if (mapItems != null && mapItems.isNotEmpty) {
      _setItems(mapItems, defaultKeyIndex, defaultValueIndex);
      setState(() {});
    }
  }

  /// 设置数据
  void setItems(Map<String, List<T>> mapItems,
      {int defaultKeyIndex, int defaultValueIndex}) {
    if (_mapItems.isNotEmpty) {
      _mapItems.clear();
    }
    if (mapItems != null && mapItems.isNotEmpty) {
      _setItems(mapItems, defaultKeyIndex, defaultValueIndex);
    }
    setState(() {});
  }
}
