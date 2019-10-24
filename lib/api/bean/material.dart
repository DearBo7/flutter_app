class MaterialEntity {
  int id;
  String ocrKey;
  String materialName;
  String materialKey;
  String batchFormat;
  int batchFormatId;
  String materialCode;
  double netWeight;
  double tareWeight;
  String materialTypeName;

  /// 批号-原料列表显示
  String materialBatch;

  /// 原料列表显示
  double storeQuantity;

  //原料id-识别原料有用
  int materialId;

  //原料相似度-识别使用
  double similarity;

  MaterialEntity(
      {this.ocrKey,
      this.materialName,
      this.materialKey,
      this.netWeight,
      this.batchFormat,
      this.batchFormatId,
      this.materialCode,
      this.id,
      this.tareWeight,
      this.materialTypeName,
      this.materialBatch,
      this.materialId,
      this.similarity});

  MaterialEntity.fromJson(Map<String, dynamic> json) {
    ocrKey = json['ocrKey'];
    materialName = json['materialName'];
    materialKey = json['materialKey'];
    netWeight = json['netWeight'];
    batchFormat = json['batchFormat'];
    batchFormatId = json['batchFormatId'];
    materialCode = json['materialCode'];
    id = json['Id'];
    tareWeight = json['tareWeight'];
    materialTypeName = json['materialTypeName'];
    materialBatch = json['materialBatch'];
    storeQuantity = json['storeQuantity'];
    materialId = json['materialId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ocrKey'] = this.ocrKey;
    data['materialName'] = this.materialName;
    data['materialKey'] = this.materialKey;
    data['netWeight'] = this.netWeight;
    data['batchFormat'] = this.batchFormat;
    data['batchFormatId'] = this.batchFormatId;
    data['materialCode'] = this.materialCode;
    data['Id'] = this.id;
    data['tareWeight'] = this.tareWeight;
    data['materialTypeName'] = this.materialTypeName;
    data['materialBatch'] = this.materialBatch;
    data['storeQuantity'] = this.storeQuantity;
    data['materialId'] = this.materialId;
    return data;
  }
}
