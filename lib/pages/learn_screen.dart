import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:lpinyin/lpinyin.dart';

import '../api/api_service.dart';

/// SizedBox(width: 20),//SizedBox 能强制子控件具有特定宽度、高度或两者都有,使子控件设置的宽高失效
class LearnScreen extends StatefulWidget {
  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  //字体样式
  final TextStyle _textGrey_14 = TextStyle(fontSize: 14.0, color: Colors.grey);

  //字体样式
  final TextStyle _textGrey_18 = TextStyle(fontSize: 18.0, color: Colors.grey);

  ///原料属性-----start-----
  GlobalKey _stackKey = GlobalKey();

  //控制展开显示/隐藏
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  String _dropDownHeaderItemTitle = "请选择原料";

  int _selectTempFirstLevelIndex = -1;
  int _selectFirstLevelIndex = -1;
  int _selectSecondLevelIndex = -1;

  final Map<String, List<MaterialEntity>> mapMaterialList = {}; //原料左右数据
  final List<MaterialEntity> valueSecondLevelList = []; //原料右边value
  final List<String> keyFirstLevelList = []; //原料左边key
  MaterialEntity _selectMaterial; //选中的原料

  ///原料属性-----end-----

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initData() async {
    List<MaterialEntity> thisMaterialList =
        await ApiService.getInstance().getListMaterial();
    if (thisMaterialList.length > 0) {
      //排序
      thisMaterialList.sort((a, b) => a.materialName.compareTo(b.materialName));
      /*thisMaterialList.sort((a, b) {
        List<int> al =
            PinyinHelper.getFirstWordPinyin(a.materialName.trim()).codeUnits;
        List<int> bl =
            PinyinHelper.getFirstWordPinyin(b.materialName.trim()).codeUnits;
        for (int i = 0; i < al.length; i++) {
          if (bl.length <= i) {
            return 1;
          }
          if (al[i] > bl[i]) {
            return 1;
          } else if (al[i] < bl[i]) {
            return -1;
          }
        }
        return 0;
      });*/
      mapMaterialList["全部"] = thisMaterialList;
      mapMaterialList["#"] = [];

      //列表转成键值对,key(A-Z)-value分类
      for (int i = 0; i < thisMaterialList.length; i++) {
        var item = thisMaterialList[i];
        String pinyinKey = PinyinHelper.getShortPinyin(
            item.materialName.trim().substring(0, 1));
        //不是A-Z就替换成 #
        if (RegExp("[A-Z]").hasMatch(pinyinKey) ||
            RegExp("[a-z]").hasMatch(pinyinKey)) {
          pinyinKey = pinyinKey.toUpperCase();
        } else {
          pinyinKey = "#";
        }
        List<MaterialEntity> thisMapList = mapMaterialList[pinyinKey];
        if (thisMapList != null) {
          thisMapList.add(item);
        } else {
          mapMaterialList[pinyinKey] = [item];
        }
      }
      if (mapMaterialList["#"].length == 0) {
        mapMaterialList.remove("#");
      }
      setState(() {
        keyFirstLevelList.addAll(mapMaterialList.keys.toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          color: Theme.of(context).primaryColor,
        ),
        preferredSize: Size(double.infinity, 0.0),
      ),
      body: Stack(
        key: _stackKey,
        children: <Widget>[
          Column(children: <Widget>[
            Row(children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 2.0),
                child: Text("原料:", style: _textGrey_18),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: GZXDropDownHeader(
                      items: [GZXDropDownHeaderItem(_dropDownHeaderItemTitle)],
                      // GZXDropDownHeader对应第一父级Stack的key
                      stackKey: _stackKey,
                      // controller用于控制menu的显示或隐藏
                      controller: _dropdownMenuController,
                      borderWidth: 1,
                      borderColor: Colors.grey[400]),
                ),
              )
            ]),
            Expanded(
              child: ListView.separated(
                  itemCount: 100,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(leading: Text('test$index'), onTap: () {});
                  }),
            ),
          ]),
          GZXDropDownMenu(
              // controller用于控制menu的显示或隐藏
              controller: _dropdownMenuController,
              // 下拉菜单显示或隐藏动画时长
              animationMilliseconds: 500,
              menus: [
                GZXDropdownMenuBuilder(
                    dropDownHeight: 40 * 10.0,
                    dropDownWidget:
                        _buildAddressWidget((selectValue, selectItem) {
                      setState(() {
                        _dropDownHeaderItemTitle = selectValue;
                        _selectMaterial = selectItem;
                        _dropdownMenuController.hide();
                      });
                    })),
              ]),
        ],
      ),
    );
  }

  //原料下拉列表
  _buildAddressWidget(
      void itemOnTap(String selectValue, MaterialEntity selectItem)) {
    return keyFirstLevelList.isEmpty
        ? Container(
            alignment: Alignment.center,
            child: Text("暂无原料数据", style: TextStyle(color: Theme.of(context).primaryColor)))
        : Row(
            children: <Widget>[
              Container(
                width: 80,
                child: ListView.builder(
                    itemCount: keyFirstLevelList.length,
                    itemBuilder: (context, index) {
                      var itemKey = keyFirstLevelList[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectTempFirstLevelIndex = index;
                            valueSecondLevelList.clear();
                            valueSecondLevelList
                                .addAll(mapMaterialList[itemKey]);
                          });
                        },
                        child: Container(
                          height: 40,
                          color: _selectTempFirstLevelIndex == index
                              ? Colors.grey[200]
                              : Colors.white,
                          alignment: Alignment.center,
                          child: _selectTempFirstLevelIndex == index
                              ? Text("$itemKey",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ))
                              : Text("$itemKey"),
                        ),
                      );
                    }),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: mapMaterialList.isEmpty
                      ? Container()
                      : ListView(
                          children: valueSecondLevelList.map((item) {
                            int index = valueSecondLevelList.indexOf(item);
                            return InkWell(
                                onTap: () {
                                  _selectSecondLevelIndex = index;
                                  _selectFirstLevelIndex =
                                      _selectTempFirstLevelIndex;
                                  itemOnTap(item.materialName, item);
                                },
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 5.0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(children: <Widget>[
                                    _selectFirstLevelIndex ==
                                                _selectTempFirstLevelIndex &&
                                            _selectSecondLevelIndex == index
                                        ? Text("${item.materialName}",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor))
                                        : Text("${item.materialName}"),
                                  ]),
                                ));
                          }).toList(),
                        ),
                ),
              )
            ],
          );
  }
}
