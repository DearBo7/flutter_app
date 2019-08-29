class ProduceLineEntity {
  int id;
  String produceLineCode;
  String produceLineName;

  ProduceLineEntity({this.id, this.produceLineCode, this.produceLineName});

  ProduceLineEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    produceLineCode = json['produceLineCode'];
    produceLineName = json['produceLineName'];
  }

  static List<ProduceLineEntity> fromJsonList(dynamic mapList) {
    List<ProduceLineEntity> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = ProduceLineEntity.fromJson(mapList[i]);
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['produceLineCode'] = this.produceLineCode;
    data['produceLineName'] = this.produceLineName;
    return data;
  }
}
