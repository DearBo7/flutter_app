import 'package:flutter/material.dart';

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
      return UserEntity.fromJsonList(resultData.data);
    }
    return [];
  }

  /// 获取生产线列表
  Future<List<ProduceLineEntity>> getListProduceLine(
      {BuildContext context}) async {
    ResultData resultData =
        await get(ApiUrl.getListProduceLine(), context: context);
    if (resultData.toast()) {
      return ProduceLineEntity.fromJsonList(resultData.data);
    }
    return [];
  }

  /// 获取配方列表
  Future<List<FormulaEntity>> getListFormula({BuildContext context}) async {
    ResultData resultData =
        await get(ApiUrl.getListFormula(), context: context);
    if (resultData.toast()) {
      return FormulaEntity.fromJsonList(resultData.data);
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
      return StoreInEntity.fromJsonList(resultData.data);
    }
    return [];
  }

  /// 获取所有原料
  Future<List<MaterialEntity>> getListMaterial({BuildContext context}) async {
    ResultData resultData =
        await get(ApiUrl.getListMaterial(), context: context);
    if (resultData.toast()) {
      return MaterialEntity.fromJsonList(resultData.data);
    }
    return [];
  }

  /// 获取领料单明细接口-根据StoreInId
  Future<ResultData> getGetStoreInListByStoreInId(int storeInId,
      {BuildContext context}) async {
    Map<String, dynamic> params = {"id": storeInId};
    ResultData resultData = await get(ApiUrl.getGetStoreInListByStoreInId(),
        params: params, context: context);
    resultData.toast();
    resultData.setResultData(resultData.isSuccess()
        ? MaterialEntity.fromJsonList(resultData.data)
        : []);
    return resultData;
  }
}
