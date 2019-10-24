import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/file_utils.dart';
import 'package:flutter_app/utils/network/net_log_utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../../provider/view_state_model.dart';
import '../../../public_index.dart';
import '../../../ui/widget/loading/loading_dialog.dart';
import '../../../utils/date_utils.dart';

typedef OrcImageCallback(
    OcrResultEntity data, CustomizeLoadingDialog loadingDialog);
typedef OrcOnCancel();

typedef OrcOnError(OcrResultEntity data);

class OrcCameraModel extends ViewStateModel {
  static const String kAccessToken = 'orc_access_token';
  static const String kUpdateDate = 'orc_update_date';
  static const int maxDay = 30;
  String _accessToken;
  int _updateMilliseconds;

  OrcCameraModel() {
    _accessToken = SpUtil.getString(kAccessToken, defValue: null);
    _updateMilliseconds = SpUtil.getInt(kUpdateDate, defValue: null);
  }

  //初始化调用,请求token
  void initToken() {
    getOrcAccessToken();
  }

  //获取token
  Future<String> getOrcAccessToken({BuildContext context}) async {
    String accessToken = _accessToken;
    //如果_accessToken为null就直接请求token,判断有效日期大于或者等于 maxDay
    if (ObjectUtils.isBlank(accessToken) ||
        DateUtils.millisecondDifferenceDay(
                _updateMilliseconds, DateUtils.currentTimeMillis()) >=
            maxDay) {
      accessToken = await getOrcRequestAccessToken(context: context);
      updateAccessToken(accessToken);
    }
    NetLogUtils.printLog("getOrcAccessToken===>accessToken:$accessToken",
        tag: "OrcCameraModel");
    return accessToken;
  }

  /// 请求识别token
  Future<String> getOrcRequestAccessToken({BuildContext context}) async {
    setBusy(true);
    String authToken = await FormulaApiService.getInstance()
        .getAuthToken(context: context, loadingText: "获取token中.");
    if (ObjectUtils.isNotBlank(authToken)) {
      setBusy(false);
    } else {
      setEmpty();
    }
    return Future.value(authToken);
  }

  ///更新token,更新时间
  bool updateAccessToken(String authToken) {
    if (ObjectUtils.isNotBlank(authToken)) {
      _accessToken = authToken;
      _updateMilliseconds = DateUtils.currentTimeMillis();
      notifyListeners();
      SpUtil.setString(kAccessToken, authToken);
      SpUtil.setInt(kUpdateDate, _updateMilliseconds);
      return true;
    }
    return false;
  }

  void orcCameraImage(BuildContext context, OrcImageCallback orcImageCallback,
      {OrcOnError onError, OrcOnCancel onCancel}) async {
    String accessToken = await getOrcAccessToken(context: context);
    if (accessToken == null) {
      if (onCancel != null) {
        onCancel();
      }
      //ToastUtil.show("识别Token获取异常,请重新获取!");
      return;
    }
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      var loadingDialog = CustomizeLoadingDialog(context)
          .show(contentText: "图片处理中...", isShowText: true);
      String orcFilePath = await FileUtils.getOrcFilePath();
      //压缩图片
      File result = await FlutterImageCompress.compressAndGetFile(
        image.path,
        orcFilePath,
        minWidth: 960,
        minHeight: 540,
        quality: 60,
      );
      if (result != null) {
        image.deleteSync();
      }
      //String accessToken = "24.4182004e3db54d2aa06f0fc1f2070fa3.2592000.1573292821.282335-17374454";
      loadingDialog.update(contentText: "识别中...");
      OcrResultEntity ocrResultEntity = await FormulaApiService.getInstance()
          .basicGeneral(accessToken, imageFile: result);
      if (ocrResultEntity != null && orcImageCallback != null) {
        orcImageCallback(ocrResultEntity, loadingDialog);
        return;
      } else if (onError != null) {
        onError(ocrResultEntity);
      }
      loadingDialog.hide();
    } else {
      if (onCancel != null) {
        onCancel();
      }
    }
  }
}
