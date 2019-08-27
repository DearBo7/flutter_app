class StoreIn {
  String formulaName;
  String creator;
  String billCode;
  int id;
  String produceLineName;
  String createDate;

  StoreIn(
      {this.formulaName,
      this.creator,
      this.billCode,
      this.id,
      this.produceLineName,
      this.createDate});

  StoreIn.fromJson(Map<String, dynamic> json) {
    formulaName = json['formulaName'];
    creator = json['creator'];
    billCode = json['billCode'];
    id = json['Id'];
    produceLineName = json['produceLineName'];
    createDate = json['createDate'];
  }

  static List<StoreIn> fromJsonList(dynamic mapList) {
    List<StoreIn> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = StoreIn.fromJson(mapList[i]);
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formulaName'] = this.formulaName;
    data['creator'] = this.creator;
    data['billCode'] = this.billCode;
    data['Id'] = this.id;
    data['produceLineName'] = this.produceLineName;
    data['createDate'] = this.createDate;
    return data;
  }
}
