import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../public_index.dart';

import '../utils/base64_util.dart';
import '../utils/toast_utils.dart';
import 'api_url.dart';
import 'basic_net_service.dart';
import 'bean/bean_index.dart';

export 'api_url.dart';
export 'basic_net_service.dart';
export 'bean/bean_index.dart';

class ApiService extends BasicNetService {
  //私有_
  ApiService._();

  static ApiService _apiService;

  static ApiService getInstance() {
    if (_apiService == null) {
      _apiService = ApiService._();
    }
    return _apiService;
  }

  /// 登录
  Future<UserEntity> getLogin(String userName, String pwd,
      {BuildContext context}) async {
    Map<String, dynamic> params = {"userName": userName, "pwd": pwd};
    ResultData resultData =
    await post(ApiUrl.getLoginUrl(), params: params, context: context);
    if (resultData.toast()) {
      return UserEntity.fromJson(resultData.data);
    }
    return null;
  }

  ///获取用户列表
  Future<List<UserEntity>> getListUser({BuildContext context}) async {
    ResultData resultData = await get(ApiUrl.getListUser(), context: context);
    if (resultData.toast()) {
      return JsonUtils.parseList(
          resultData.data, (v) => UserEntity.fromJson(v));
    }
    return [];
  }

  /// 获取生产线列表
  Future<List<ProduceLineEntity>> getListProduceLine(
      {BuildContext context}) async {
    ResultData resultData =
    await get(ApiUrl.getListProduceLine(), context: context);
    if (resultData.toast()) {
      return JsonUtils.parseList(
          resultData.data, (v) => ProduceLineEntity.fromJson(v));
    }
    return [];
  }

  /// 获取配方列表
  Future<List<FormulaEntity>> getListFormula({BuildContext context}) async {
    ResultData resultData =
    await get(ApiUrl.getListFormula(), context: context);
    if (resultData.toast()) {
      return JsonUtils.parseList(
          resultData.data, (v) => FormulaEntity.fromJson(v));
    }
    return [];
  }

  /// 获取领料单列表
  /// 参数：[startDate:,endDate:]必传,produceLineId,formulaId
  Future<List<StoreInEntity>> getListStoreIn(String startDate, String endDate,
      {int produceLineId,
        int formulaId,
        BuildContext context,
        bool showLoad}) async {
    Map<String, dynamic> params = {};
    params["startDate"] = startDate;
    params["endDate"] = endDate;
    if (produceLineId != null && produceLineId > 0) {
      params["produceLineId"] = produceLineId;
    }
    if (formulaId != null && formulaId > 0) {
      params["formulaId"] = formulaId;
    }
    ResultData resultData = await get(ApiUrl.getListStoreIn(),
        params: params, context: context, showLoad: showLoad);
    if (resultData.toast()) {
      return JsonUtils.parseList(
          resultData.data, (v) => StoreInEntity.fromJson(v));
    }
    return [];
  }

  /// 获取所有原料
  Future<List<MaterialEntity>> getListMaterial({BuildContext context}) async {
    ResultData resultData =
    await get(ApiUrl.getListMaterial(), context: context);
    if (resultData.toast()) {
      return JsonUtils.parseList(
          resultData.data, (v) => MaterialEntity.fromJson(v));
    }
    return [];
  }

  /// 获取领料单明细接口-根据StoreInId
  Future<ResultData> getGetStoreInListByStoreInId(int storeInId,
      {BuildContext context, bool showLoad}) async {
    Map<String, dynamic> params = {"id": storeInId};
    ResultData resultData = await get(ApiUrl.getGetStoreInListByStoreInId(),
        params: params, context: context, showLoad: showLoad);
    if (resultData.toast()) {
      resultData.setResultData(JsonUtils.parseList(
          resultData.data, (v) => MaterialEntity.fromJson(v)));
    } else {
      resultData.setResultData([]);
    }

    return resultData;
  }

  /// 获取物料批次规则列表
  Future<List<MaterialBatchFormatEntity>> getListMaterialBatchFormat(
      {BuildContext context}) async {
    ResultData resultData =
    await get(ApiUrl.getListMaterialBatchFormat(), context: context);
    if (resultData.toast()) {
      return JsonUtils.parseList(
          resultData.data, (v) => MaterialBatchFormatEntity.fromJson(v));
    }
    return [];
  }

  /// 修改原料OrcKey,修改学习界面保存按钮信息
  Future<ResultData> getUpdateMaterialOcrKey(Map<String, dynamic> params,
      {BuildContext context}) async {
    ResultData resultData = await post(ApiUrl.getUpdateMaterialOcrKey(),
        params: params, context: context);
    resultData.toast(errorMsg: "提交失败");
    return resultData;
  }

  /// 单个物料复核并打印接口
  Future<ResultData> getVerifyStoreIn(
      int id, String materialBatch, int packageCount, String creator,
      {BuildContext context}) async {
    Map<String, dynamic> params = {
      "id": id,
      "materialBatch": materialBatch,
      "packageCount": packageCount,
      "creator": creator
    };
    ResultData resultData =
    await post(ApiUrl.getVerifyStoreIn(), params: params, context: context);
    resultData.toast(errorMsg: "提交失败");
    return resultData;
  }

  //获取百度识别token
  Future<String> getAuthToken(
      {String ak: "79rZISjsTMAoE6oaV1qwPlSK",
        String sk: "QXzPAgmfbu54Uvek29OsfirZWBFb5OBP",
        BuildContext context,
        String loadingText}) async {
    // 获取token地址
    String tokenUrl = "https://aip.baidubce.com/oauth/2.0/token";
    //var ak = "79rZISjsTMAoE6oaV1qwPlSK";
    //var sk = "QXzPAgmfbu54Uvek29OsfirZWBFb5OBP";
    //1. grant_type为固定参数,2. client_id官网获取的 API Key,3. client_secret官网获取的 Secret Key
    Map<String, dynamic> params = {
      "grant_type": "client_credentials",
      "client_id": ak,
      "client_secret": sk
    };
    ResultData resultData = await get(tokenUrl,
        params: params,
        contentType: Headers.jsonContentType,
        context: context,
        loadingText: loadingText);
    if (resultData.isBaiDuSuccess() &&
        resultData.response.containsKey("access_token")) {
      String accessToken = resultData.response["access_token"].toString();
      if (ObjectUtils.isBlank(accessToken)) {
        ToastUtil.show("获取token失败,请从新获取!");
        return null;
      }
      return accessToken;
    }
    resultData.toastBaiDuError(errorMsg: "获取识别token异常!");
    return null;
  }

  //文字识别
  Future<OcrResultEntity> basicGeneral(String accessToken,
      {File imageFile,
        String url,
        BuildContext context,
        String loadingText}) async {
    String orcUrl = "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic";
    Map<String, dynamic> params = {"access_token": accessToken};
    if (imageFile != null) {
      params["image"] = await Base64Utils.imageFile2Base64(imageFile);
    } else if (url != null) {
      params["url"] = url;
    } else {
      return null;
    }
    ResultData resultData = await post(orcUrl,
        params: params,
        contentType: Headers.formUrlEncodedContentType,
        loadingText: loadingText,
        context: context);
    if (resultData.isBaiDuSuccess() &&
        resultData.response.containsKey("log_id") &&
        !resultData.response.containsKey("error_code")) {
      return OcrResultEntity.fromJson(resultData.response);
    }
    resultData.toastBaiDuError(errorMsg: "文字识别异常!");
    return null;
  }
}
