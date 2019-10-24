class StoreInMaterialEntity {
  String materialName;
  String produceDate;
  String materialBatch;
  String qrCode;
  String optDate;
  String optUserName;
  String produceLineName;
  String materialTypeName;

  //是否打印-打印状态,null初始,false打印失败,true打印成功
  bool printFlag;

  StoreInMaterialEntity(
      {this.materialName,
      this.produceDate,
      this.materialBatch,
      this.qrCode,
      this.optDate,
      this.optUserName,
      this.produceLineName,
      this.materialTypeName,
      this.printFlag});

  StoreInMaterialEntity.fromJson(Map<String, dynamic> json) {
    materialName = json['materialName'];
    produceDate = json['produceDate'];
    materialBatch = json['materialBatch'];
    qrCode = json['qrCode'];
    optDate = json['optDate'];
    optUserName = json['optUserName'];
    produceLineName = json['produceLineName'];
    materialTypeName = json['materialTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['materialName'] = this.materialName;
    data['produceDate'] = this.produceDate;
    data['materialBatch'] = this.materialBatch;
    data['qrCode'] = this.qrCode;
    data['optDate'] = this.optDate;
    data['optUserName'] = this.optUserName;
    data['produceLineName'] = this.produceLineName;
    data['materialTypeName'] = this.materialTypeName;
    return data;
  }
}
