import 'package:flutter/material.dart';

import '../public_index.dart';
import 'base/basic_net_service.dart';
import 'bean/bean_index.dart';
import 'url/api_url.dart';

export '../utils/network/result_data.dart';
export 'bean/bean_index.dart';
export 'url/api_url.dart';

class PeopleApiService extends BasicNetService {
  //私有_
  PeopleApiService._();

  static PeopleApiService _apiService;

  static PeopleApiService getInstance() {
    if (_apiService == null) {
      _apiService = PeopleApiService._();
    }
    return _apiService;
  }

  /// 百姓生活分类数据接口
  Future<List<CategoryEntity>> getCategoryList({BuildContext context}) async {
    ResultData resultData =
        await post(PeopleApiUrl.getCategoryUrl(), context: context);
    if (resultData.toast(successCode: "0")) {
      return JsonUtils.parseList(
          resultData.data, (v) => CategoryEntity.fromJson(v));
    }
    return [];
  }

  /// 根据分类获取商品列表
  Future<List<MallGoodEntity>> getMallGoodByCategoryList(
      int page, String categoryId,
      {String categorySubId, BuildContext context}) async {
    Map<String, dynamic> params = {"page": page, "categoryId": categoryId};
    if (ObjectUtils.isNotBlank(categorySubId)) {
      params["categorySubId"] = categorySubId;
    }
    ResultData resultData = await post(PeopleApiUrl.getMallGoodsUrl(),
        params: params, context: context);
    if (resultData.toast(successCode: "0")) {
      return JsonUtils.parseList(
          resultData.data, (v) => MallGoodEntity.fromJson(v));
    }
    return [];
  }
}
