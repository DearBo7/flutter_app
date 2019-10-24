import '../../utils/sp_util.dart';

///FormulaUrl
class FormulaApiUrl {
  static const String kRestUrl = 'formula_rest_url';
  static const String RestUrl = "http://ocr.xtits.cn:8896";

  static String getRestUrl() {
    return SpUtil.getString(kRestUrl, defValue: RestUrl);
  }

  /// 登录验证  参数:userName,pwd
  static String getLoginUrl() {
    return getRestUrl() + "/default/login";
  }

  /// 获取用户列表
  static String getListUser() {
    return getRestUrl() + "/default/listUser";
  }

  /// 获取所有生产线列表
  static String getListProduceLine() {
    return getRestUrl() + "/default/listProduceLine";
  }

  /// 获取所有已审核配方列表
  static String getListFormula() {
    return getRestUrl() + "/default/listFormula";
  }

  /// 获取领料单接口-by2019年5月28日15:24:23 新增
  /// 参数：[startDate:,endDate:]必传,produceLineId,formulaId
  static String getListStoreIn() {
    return getRestUrl() + "/default/listStoreIn";
  }

  /// 获取所有原料列表
  static String getListMaterial() {
    return getRestUrl() + "/default/listMaterial";
  }

  /// 获取领料单明细接口-by2019年5月28日15:24:23 新增
  /// 参数：id=1
  static String getGetStoreInListByStoreInId() {
    return getRestUrl() + "/default/getStoreInListByStoreInId";
  }
}

///百姓生活Url
class PeopleApiUrl {
  static const String kPeopleRestUrl = 'people_rest_url';
  static const String PeopleRestUrl =
      "http://v.jspang.com:8088/baixing/wxmini";

  static String getRestUrl() {
    return SpUtil.getString(kPeopleRestUrl, defValue: PeopleRestUrl);
  }

  /// 百姓生活分类数据接口,一级分类,二级分类
  static String getCategoryUrl() {
    return getRestUrl() + "/getCategory";
  }

  /// 百姓生活分类商品数据接口
  /// "page": page,
  //  "categoryId": categoryId,
  //  "categorySubId": categorySubId,
  static String getCategoryGoodsUrl() {
    return getRestUrl() + "/getMallGoods";
  }

  /// 百姓生活分类商品数据接口
  /// "goodId": goodId
  static String getGoodsDetailUrl() {
    return getRestUrl() + "/getGoodDetailById";
  }
}
