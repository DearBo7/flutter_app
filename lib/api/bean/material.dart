class MaterialEntity{
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
      this.materialTypeName});

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
  }

  static List<MaterialEntity> fromJsonList(dynamic mapList) {
    List<MaterialEntity> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = MaterialEntity.fromJson(mapList[i]);
    }
    return list;
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
    return data;
  }
}
