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

  ///获取用户列表
  Future<List<User>> getListUser({BuildContext context}) async {
    ResultData resultData = await get(ApiUrl.getListUser(), context: context);
    resultData.toast();
    if (resultData.isSuccess()) {
      return User.fromJsonList(resultData.data);
    }
    return [];
  }

  /// 获取生产线列表
  Future<List<ProduceLine>> getListProduceLine({BuildContext context}) async {
    ResultData resultData =
        await get(ApiUrl.getListProduceLine(), context: context);
    resultData.toast();
    if (resultData.isSuccess()) {
      return ProduceLine.fromJsonList(resultData.data);
    }
    return [];
  }

  /// 获取配方列表
  Future<List<Formula>> getListFormula({BuildContext context}) async {
    ResultData resultData =
        await get(ApiUrl.getListFormula(), context: context);
    resultData.toast();
    if (resultData.isSuccess()) {
      return Formula.fromJsonList(resultData.data);
    }
    return [];
  }

  /// 获取领料单列表
  /// 参数：[startDate:,endDate:]必传,produceLineId,formulaId
  Future<List<StoreIn>> getListStoreIn(String startDate, String endDate,
      {int produceLineId, int formulaId,BuildContext context}) async {
    Map<String, dynamic> params = {};
    params["startDate"] = startDate;
    params["endDate"] = endDate;
    if (produceLineId != null && produceLineId > 0) {
      params["produceLineId"] = produceLineId;
    }
    if (formulaId != null && formulaId > 0) {
      params["formulaId"] = formulaId;
    }
    ResultData resultData = await get(ApiUrl.getListStoreIn(), params: params);
    resultData.toast();
    if (resultData.isSuccess()) {
      return StoreIn.fromJsonList(resultData.data);
    }
    return [];
  }
}
