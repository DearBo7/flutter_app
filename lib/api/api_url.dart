import '../utils/sp_util.dart';

class ApiUrl {
  static const String kRestUrl = 'api_rest_url';
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

  /// 获取物料批次规则列表-by:2019年2月14日16:09:47 新增
  static String getListMaterialBatchFormat() {
    return getRestUrl() + "/default/listMaterialBatchFormat";
  }

  /// 修改原料OrcKey
  /// {materialId:1506,ocrKey:"xxxxxxxxxx"}
  static String getUpdateMaterialOcrKey() {
    return getRestUrl() + "/default/updateMaterialOcrKey";
  }

  /// 单个物料复核并打印接口-by2019年5月28日15:24:23 新增
  /// 参数: id,materialBatch,packageCount,creator
  static String getVerifyStoreIn() {
    return getRestUrl() + "/default/verifyStoreIn";
  }
}
