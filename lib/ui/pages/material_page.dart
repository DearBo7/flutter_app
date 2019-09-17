import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../public_index.dart';
import '../../utils/file_utils.dart';
import '../widget/customize_widgets.dart';
import '../widget/empty/empty_list_widget.dart';
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
  File _imageFile;

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
        title: Text(S.of(context).materialList),
        leading: IconButton(
          icon: Icon(CustomIcon.back, size: 32.0),
          onPressed: () {
            Navigator.pop(context, widget.storeIn.id);
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                CustomIcon.scan,
                size: 32.0,
              ),
              onPressed: () async {
                ToastUtil.show("拍照");
                //String orcPath = await FileUtils.getOrcFilePath();
                //Toast.show(context, orcPath);
                getCameraImage();
                /*final result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PhotoImage()));
                if (result != null) {

                }*/
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
                  SizedBox(height: 10),
                  RowLabelToWidgetOne(
                    Text("名称:", style: TextStyles.labelTitle),
                    rightWidget: MaterialContainer(
                      backgroundColor: Colors.grey[300],
                      child: Text("名称", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  SizedBox(height: 15),
                  RowLabelToWidgetOne(
                    Text("批次:", style: TextStyles.labelTitle),
                    rightWidget: MaterialContainer(
                      child: Text("批次内容"),
                    ),
                  ),
                  SizedBox(height: 15),
                  RowLabelToWidgetOne(
                    Text("包数:", style: TextStyles.labelTitle),
                    rightWidget: MaterialContainer(
                      backgroundColor: Colors.grey[300],
                      child: Text("1", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: RaisedButton(
                      onPressed: () {
                        ToastUtil.show("RaisedButton");
                      },
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryColor.value ==
                              Colors.white.value
                          ? Colors.black
                          : Colors.white,
                      child: Text("提交"),
                    ),
                  ),
                ],
              ),
            ),
            /*Container(
              height: 250.0,
              child: _previewImage(),
            ),*/
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

  Future getCameraImage() async {
    var loadingDialog = CustomizeLoadingDialog(context).show();
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      String orcFilePath = await FileUtils.getOrcFilePath();
      File result = await FlutterImageCompress.compressAndGetFile(
        image.path,
        orcFilePath,
        quality: 50,
      );
      if (result != null) {
        //image.deleteSync();
      }
      loadingDialog.hide();
      setState(() {
        _imageFile = result;
      });
    } else {
      loadingDialog.hide();
    }
  }

  Widget _previewImage() {
    return _imageFile != null
        ? Image(image: FileImageEx(_imageFile))
        : Text("请拍照.");
  }
}

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

class MaterialContainer extends StatelessWidget {
  MaterialContainer({this.child, this.backgroundColor});

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.grey[400], width: 0.5),
          borderRadius: new BorderRadius.all(Radius.circular(3.0)),
        ),
        child: child);
  }
}
