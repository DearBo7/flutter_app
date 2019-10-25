import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../public_index.dart';
import '../../widget/custom/custom_empty_widget.dart';
import '../../widget/custom/custom_widgets.dart';
import '../../widget/edit_drop_select.dart';
import '../../widget/loading/loading_dialog.dart';

class FormulaMaterialPage extends StatefulWidget {
  final StoreInEntity storeIn;

  const FormulaMaterialPage({Key key, this.storeIn}) : super(key: key);

  @override
  _FormulaMaterialPageState createState() => _FormulaMaterialPageState();
}

class _FormulaMaterialPageState extends State<FormulaMaterialPage> {
  //列表数据
  final List<MaterialEntity> materialListGlobal = [];

  File _imageFile;

  final _batchKey = GlobalKey<AutoSelectTextFieldState<String>>();

  final List<String> batchList = [];

  //识别出来的原料
  MaterialEntity _selectMaterialEntity;

  //批次值
  TextEditingController _batchValueController = TextEditingController();

  //包数-默认为1
  int _packageCount = 1;

  //是否提交数据
  bool _submitDataFlag = false;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).materialListTitle),
        leading: IconButton(
          icon: Icon(CustomIcon.back, size: 30.0),
          onPressed: () {
            Navigator.pop(context, _submitDataFlag);
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 30.0,
              ),
              onPressed: () async {
                //String authToken = await FormulaApiService.getInstance().getAuthToken();
                //print('authToken:$authToken');
                //拍照-识别-匹配原料
                _getCameraImageAndOrcMaterial(context);
              })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Gaps.hGap5,
                  RowLabelToWidgetOne(
                    Text(S.of(context).nameTitle, style: TextStyles.labelTitle),
                    rightWidget: TextContainer(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      margin: EdgeInsets.only(left: 10.0),
                      backgroundColor: Colors.grey[300],
                      child: Text(
                          _selectMaterialEntity == null
                              ? ""
                              : _selectMaterialEntity.materialName,
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  SizedBox(height: 10),
                  RowLabelToWidgetOne(
                    Text(S.of(context).batchTitle,
                        style: TextStyles.labelTitle),
                    rightWidget: Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: AutoSelectTextField<String>(
                        key: _batchKey,
                        items: batchList,
                        minLength: 0,
                        filterFlag: false,
                        controller: _batchValueController,
                      ),
                    ),
                  ),
                  Gaps.hGap10,
                  RowLabelToWidgetOne(
                    Text(S.of(context).packageTitle,
                        style: TextStyles.labelTitle),
                    rightWidget: TextContainer(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      margin: EdgeInsets.only(left: 10.0),
                      backgroundColor: Colors.grey[300],
                      child: Text(_packageCount.toString(),
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  Gaps.hGap5,
                  //原料提交
                  Center(
                    child: RaisedButton(
                      onPressed: _selectMaterialEntity == null
                          ? null
                          : () {
                              if (_selectMaterialEntity == null) {
                                return ToastUtil.show("请扫描原料!");
                              }
                              if (ObjectUtils.isBlank(
                                  _batchValueController.text)) {
                                return ToastUtil.show("批次不能为空!");
                              }
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return WillPopScope(
                                      onWillPop: () => Future.value(false),
                                      child: AlertDialog(
                                        title: Text(S.of(context).dialogPrompt),
                                        content: Text(S
                                            .of(context)
                                            .dialogConfirmSubmitMsg),
                                        actions: <Widget>[
                                          RaisedButtons(
                                            type: ButtonEnum.Cancel,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child:
                                                Text(S.of(context).btnCancel),
                                          ),
                                          RaisedButtons(
                                            type: ButtonEnum.Confirm,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              if (!_submitDataFlag) {
                                                _submitDataFlag = true;
                                              }
                                              _submitData(
                                                  _selectMaterialEntity.id,
                                                  _batchValueController.text,
                                                  _packageCount);
                                            },
                                            child:
                                                Text(S.of(context).btnConfirm),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryColor.value ==
                              Colors.white.value
                          ? Colors.black
                          : Colors.white,
                      child: Text(S.of(context).submit),
                    ),
                  ),
                ],
              ),
            ),
            /*Container(
              height: 200.0,
              child: _previewImage(),
            ),*/
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 2.0)),
                ),
                child: materialListGlobal.isEmpty
                    ? CustomListEmptyWidget(
                        onRefresh: () {
                          initData();
                        },
                      )
                    : _buildListView(),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 构建列表
  Widget _buildListView() {
    return ListView.separated(
        itemCount: materialListGlobal.length,
        itemBuilder: (context, index) {
          var material = materialListGlobal[index];
          return Container(
            padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${material.materialName}",
                        style: TextStyles.listTitle),
                    Text("${material.storeQuantity}",
                        style: TextStyles.listSubtitle)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("${material.materialBatch}",
                        style: TextStyles.listSubtitle),
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 2.0));
  }

  /// --- 数据相关 begin---

  //提交原料数据
  _submitData(int id, String materialBatch, int packageCount) async {
    String userName = Store.value<UserModel>(context).user.userName;
    ToastUtil.show("提交成功!userName:$userName");
  }

  ///拍照后处理
  _getCameraImageAndOrcMaterial(BuildContext context) {
    if (materialListGlobal.isEmpty) {
      ToastUtil.show("当前领料单暂无可入库的原料,不能扫描!");
      return;
    }
    Store.value<OrcCameraModel>(context).orcCameraImage(context,
        (OcrResultEntity ocrResultEntity,
            CustomizeLoadingDialog loadingDialog) async {
      setOrClearMaterialValue(null);
      if (ocrResultEntity != null &&
          ocrResultEntity.wordsResult != null &&
          ocrResultEntity.wordsResult.length > 0) {
        loadingDialog.update(contentText: "原料匹配中...");
        await Future.delayed(Duration(milliseconds: 2000));
        loadingDialog.hide();
        ToastUtil.show("匹配成功!");
      } else {
        loadingDialog.hide();
        ToastUtil.show("没有识别到物料信息，请重新扫描!");
      }
    });
  }

  //更新原料,批次信息/清空原料,批次信息
  setOrClearMaterialValue(MaterialEntity _materialEntity) {
    if (_materialEntity == null) {
      //清空原料
      _selectMaterialEntity = null;
      //清空批次数据
      _batchKey.currentState.clearAll();
    } else {
      _selectMaterialEntity = _materialEntity;
      setMaterialBatchValue(_selectMaterialEntity.materialId);
    }
    setState(() {});
  }

  //根据原料id设置原料批次
  setMaterialBatchValue(int thisMaterialId) {
    Set<String> materialBatchSet = Set();
    for (MaterialEntity _material in materialListGlobal) {
      if (_material.materialBatch != null &&
          thisMaterialId == _material.materialId) {
        materialBatchSet.add(_material.materialBatch);
      }
    }
    _batchKey.currentState.setItems(materialBatchSet.toList());
    _batchValueController.text = materialBatchSet.first;
  }

  Widget _previewImage() {
    return _imageFile != null
        ? Image(image: FileImageEx(_imageFile))
        : Text("请拍照.");
  }

  /// 初始化加载数据
  void initData({bool showLoad: true}) async {
    ResultData result = await FormulaApiService.getInstance()
        .getGetStoreInListByStoreInId(widget.storeIn.id,
            context: context, showLoad: showLoad);
    setState(() {
      if (materialListGlobal.length > 0) {
        materialListGlobal.clear();
      }
      if (result.getResultData().length > 0) {
        materialListGlobal.addAll(result.getResultData());
      } else {
        ToastUtil.show("当前领料单暂无可入库的原料!");
      }
    });
  }

  /// ---数据相关 end---
}

//处理更改文件后,不刷新问题
class FileImageEx extends FileImage {
  int fileSize;

  FileImageEx(File file, {double scale = 1.0})
      : assert(file != null),
        assert(scale != null),
        super(file, scale: scale) {
    fileSize = file.lengthSync();
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final FileImageEx typedOther = other;
    return file?.path == typedOther.file?.path &&
        scale == typedOther.scale &&
        fileSize == typedOther.fileSize;
  }
}
