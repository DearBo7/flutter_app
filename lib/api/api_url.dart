class ApiUrl {
  static String REST_URL = "http://ocr.xtits.cn:8896";

  static String getRestUrl() {
    return REST_URL;
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
}
