class ProduceLine {
  int id;
  String produceLineCode;
  String produceLineName;

  ProduceLine({this.id, this.produceLineCode, this.produceLineName});

  ProduceLine.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    produceLineCode = json['produceLineCode'];
    produceLineName = json['produceLineName'];
  }

  static List<ProduceLine> fromJsonList(dynamic mapList) {
    List<ProduceLine> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = ProduceLine.fromJson(mapList[i]);
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
