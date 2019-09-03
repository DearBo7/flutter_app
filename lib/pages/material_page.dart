import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/bean/bean_index.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';

import './src/empty_list_widget.dart';
import './src/text_style_util.dart';
import '../api/api_service.dart';
import '../utils/file_utils.dart';
import '../widget/loading/loading_dialog.dart';

class MaterialPage extends StatefulWidget {
  final StoreInEntity storeIn;

  MaterialPage({Key key, @required this.storeIn}) : super(key: key);

  @override
  _MaterialPageState createState() => _MaterialPageState();
}

class _MaterialPageState extends State<MaterialPage> {
  //列表数据
  final List<MaterialEntity> materialList = [];
  File _imageFile = null;

  @override
  void initState() {
    super.initState();

    /// 在initState 里面使用 context,两种方法
    /*Future.delayed(Duration.zero, () {
    });*/
    Timer.run(() {
      initData();
    });
  }

  /// 初始化加载数据
  Future<void> initData() async {
    ResultData result = await ApiService.getInstance()
        .getGetStoreInListByStoreInId(widget.storeIn.id, context: context);
    setState(() {
      if (result.getResultData().length > 0) {
        materialList.addAll(result.getResultData());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initData();
    return Scaffold(
      appBar: AppBar(
        title: Text("原料列表"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 32.0),
          onPressed: () {
            Navigator.pop(context, widget.storeIn.id);
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings_overscan,
                size: 32.0,
              ),
              onPressed: () async {
                //Toast.show(context, "拍照", duration: Toast.LENGTH_SHORT);
                //String orcPath = await FileUtils.getOrcFilePath();
                //Toast.show(context, orcPath);
                getCameraImage();
                /*final result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PhotoImage()));
                if (result != null) {

                }*/

                /*ShowParam showParam;
                LoadingDialogUtil.showTextLoadingDialog(
                    context, showParam = new ShowParam());
                testStartTime(showParam);*/
              })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("名称:", style: textStyleGrey_18),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                          margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[350],
                            border:
                                Border.all(color: Colors.grey[400], width: 0.5),
                            borderRadius: new BorderRadius.vertical(
                                top: Radius.elliptical(3, 3),
                                bottom: Radius.elliptical(3, 3)),
                          ),
                          child:
                              Text("名称", style: TextStyle(color: Colors.red)),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("批次:", style: textStyleGrey_18),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                          margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[400], width: 0.5),
                            borderRadius: new BorderRadius.vertical(
                                top: Radius.elliptical(3, 3),
                                bottom: Radius.elliptical(3, 3)),
                          ),
                          child: Text("批次内容"),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("包数:", style: textStyleGrey_18),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                          margin: EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[350],
                            border:
                                Border.all(color: Colors.grey[400], width: 0.5),
                            borderRadius: new BorderRadius.vertical(
                                top: Radius.elliptical(3, 3),
                                bottom: Radius.elliptical(3, 3)),
                          ),
                          child: Text("1", style: TextStyle(color: Colors.red)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 320.0,
              child: _previewImage(),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 2.0)),
                ),
                child:
                    materialList.isEmpty ? EmptyListWidget() : _buildListView(),
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
        itemCount: materialList.length,
        itemBuilder: (context, index) {
          var material = materialList[index];
          return Container(
            padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${material.materialName}", style: textStyleBlack_18),
                    Text("${material.storeQuantity}", style: textStyleGrey_14)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("${material.materialBatch}", style: textStyleGrey_14),
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 2.0));
  }

  Future getCameraImage() async {
    ShowParam showParam;
    LoadingDialogUtil.showTextLoadingDialog(
      context, showParam = new ShowParam());
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      String orcFilePath = await FileUtils.getOrcFilePath();
      File result = await  FlutterImageCompress.compressAndGetFile(
        image.path,
        orcFilePath,
        quality: 50,
      );
      if (result != null) {
        //image.deleteSync();
      }
      setState(() {
        _imageFile = result;
        showParam.pop();
      });
    }else{
      showParam.pop();
    }
  }

  Widget _previewImage() {
    return _imageFile != null ? Image(image: FileImageEx(_imageFile)) : Text("请拍照.");
  }

  testStartTime(ShowParam showParam, {int seconds: 3}) async {
    return new Timer(Duration(seconds: seconds), () => showParam.pop());
  }
}

class FileImageEx extends FileImage {
  int fileSize;
  FileImageEx(File file, { double scale = 1.0 })
    : assert(file != null),
      assert(scale != null),
      super(file, scale: scale) {
    fileSize = file.lengthSync();
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType)
      return false;
    final FileImageEx typedOther = other;
    return file?.path == typedOther.file?.path && scale == typedOther.scale && fileSize == typedOther.fileSize;
  }

}