import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/store/enums/enum_index.dart';
import 'package:flutter_app/ui/widget/custom/custom_empty_widget.dart';
import 'package:flutter_app/ui/widget/loading/loading_dialog.dart';
import '../../widget/expand/drop_down_menu.dart';
import '../../widget/expand/expand_view.dart';
import 'package:lpinyin/lpinyin.dart';
import '../../../public_index.dart';
import '../../../api/api_service.dart';
import '../../../res/styles.dart';
import '../src/app_bar_preferred.dart';

/// SizedBox(width: 20),//SizedBox 能强制子控件具有特定宽度、高度或两者都有,使子控件设置的宽高失效
class LearnPage extends StatefulWidget {
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {

  int _lastKeyIndex = 0;
  int _lastValueIndex = -1;

  final Map<String, List<MaterialEntity>> mapMaterialList = {}; //原料左右数据
  MaterialEntity _selectMaterial; //选中的原料

  //原料下拉框-A-Z
  final List<String> letterList = ["#"];

  ///原料属性-----end-----

  @override
  void initState() {
    super.initState();
    int charA = 'A'.codeUnitAt(0);
    letterList.addAll(
        List<String>.generate(26, (x) => String.fromCharCode(charA + x)));
    Timer.run(() {
      _getMaterialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPreferred.getPreferredSize(context),
      body: Column(children: <Widget>[
        Row(children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child:
            Text(S.of(context).materialTitle, style: TextStyles.labelTitle),
          ),
          Expanded(
            child: ExpandView(
              headComponent: TriggerComponent(
                builder: (TriggerComponentData data) {
                  /*if (data.switchFlag) {
                    _ocrKeyFocus.unfocus();
                  }*/
                  return GestureDetector(
                    onTap: data.triggerMenu,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                          border: Borders.borderGrey,
                          borderRadius: Borders.borderAllRadius3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _selectMaterial == null
                                  ? "请选择原料"
                                  : _selectMaterial.materialName,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Icon(
                            data.switchFlag
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              dropDownComponent:
              TriggerComponent(builder: (TriggerComponentData data) {
                return Container(
                  child: DropDownMenu<MaterialEntity>(
                    margin: EdgeInsets.symmetric(vertical: 3),
                    mapItems: mapMaterialList,
                    defaultKeyIndex: _lastKeyIndex,
                    defaultValueIndex: _lastValueIndex,
                    itemShowText: (v) => v.materialName,
                    onRefresh: () {
                      data.triggerMenu();
                      _getMaterialData();
                    },
                    onItemSelected:
                        (MaterialEntity item, int valueIndex, int keyIndex) {
                      _lastKeyIndex = keyIndex;
                      _lastValueIndex = valueIndex;
                      _materialChanged(item);
                      data.triggerMenu();
                    },
                  ),
                );
              }),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: _getCameraImageAndOrc,
              child: Icon(
                Icons.photo_camera,
                color: Theme.of(context).accentColor,
              ),
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
    );
  }

  //拍照识别
  void _getCameraImageAndOrc() {
    if (_selectMaterial == null) {
      return ToastUtil.show("请选择原料!");
    }
    Store.value<OrcCameraModel>(context).orcCameraImage(context,
            (OcrResultEntity ocrResultEntity,
            CustomizeLoadingDialog loadingDialog) {
          if (ocrResultEntity != null &&
              ocrResultEntity.wordsResult != null &&
              ocrResultEntity.wordsResult.length > 0) {
            StringBuffer scanDesc = new StringBuffer();
            for (WordsResultEntity word in ocrResultEntity.wordsResult) {
              scanDesc.write('"');
              scanDesc.write(word.words);
              scanDesc.write('"\n');
            }
            /*setState(() {
              _ocrKeyValueController.text = scanDesc.toString();
            });
            _ocrKeyFocus.unfocus();*/
            loadingDialog.hide();
            ToastUtil.show("识别成功!");
          } else {
            loadingDialog.hide();
            ToastUtil.show("没有识别信息，请重新扫描!");
          }
        });
  }

  //切换原料-更新关键字,标签特征,显示批次规则
  _materialChanged(MaterialEntity selectItem) {
    //设置当前选中的原料
    _selectMaterial = selectItem;
  }

  //原料列表数据
  void _getMaterialData() async {
    List<MaterialEntity> thisMaterialList =
    await ApiService.getInstance().getListMaterial(context: context);
    if (thisMaterialList.length > 0) {
      //排序
      thisMaterialList.sort((a, b) => a.materialName.compareTo(b.materialName));
      if (mapMaterialList.isNotEmpty) {
        mapMaterialList.clear();
      }
      mapMaterialList[S.of(context).all] = thisMaterialList;
      letterList.forEach((d) => mapMaterialList[d] = []);
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
      //删除没有数据的
      for (var item in letterList) {
        if (mapMaterialList[item].length == 0) {
          mapMaterialList.remove(item);
        }
      }
    }
    setState(() {});
  }
}

/// Radio 单选框
class RadioTitleList<T extends EnumEntity> extends StatefulWidget {
  final List<T> items;
  final int value;
  final ValueChanged<int> onChanged;

  const RadioTitleList(
      {Key key, this.value, @required this.onChanged, @required this.items})
      : assert(items != null);

  @override
  _RadioTitleListState createState() => _RadioTitleListState();
}

class _RadioTitleListState extends State<RadioTitleList> {
  int _groupValue;

  @override
  void initState() {
    _groupValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.items
          .map((item) => Expanded(
        child: InkWell(
          onTap: _groupValue == item.code
              ? null
              : () {
            _onChanged(item.code);
          },
          child: Row(
            children: <Widget>[
              Radio(
                value: item.code,
                groupValue: _groupValue,
                onChanged: _onChanged,
              ),
              Text(item.label)
            ],
          ),
        ),
      ))
          .toList(),
    );
  }

  void _onChanged(value) {
    setState(() {
      _groupValue = value;
    });
    widget.onChanged(value);
  }
}

class DragList extends StatefulWidget {
  final List<KeyEntity<int, dynamic>> dataList;

  const DragList({Key key, @required this.dataList}) : super(key: key);

  @override
  _DragListState createState() => _DragListState();
}

class _DragListState extends State<DragList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Utils.height,
      width: Utils.width,
      child: widget.dataList.isEmpty
          ? CustomListEmptyWidget()
          : ReorderableListView(
        children: widget.dataList
            .asMap()
            .keys
            .map((i) => Container(
          key: ValueKey(i.toString()),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Colors.grey[400],
                    width: 0.5,
                    style: BorderStyle.solid)),
          ),
          child: ListTile(
            title: Text(
                "${widget.dataList[i].label}"),
            trailing: InkWell(
              onTap: () {
                setState(() {
                  widget.dataList.removeAt(i);
                });
              },
              child: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
          ),
        ))
            .toList(),
        onReorder: (int oldIndex, int newIndex) {
          //print('oldIndex: $oldIndex , newIndex: $newIndex');
          /*if (newIndex >= widget.dataList.length) {
            newIndex = widget.dataList.length - 1;
          }*/
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          setState(() {
            var item = widget.dataList.removeAt(oldIndex);
            widget.dataList.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
