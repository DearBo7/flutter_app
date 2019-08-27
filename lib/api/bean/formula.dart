class Formula {
  int id;
  String formulaCode;
  String formulaName;

  Formula({this.id, this.formulaCode, this.formulaName});

  Formula.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    formulaCode = json['formulaCode'];
    formulaName = json['formulaName'];
  }

  static List<Formula> fromJsonList(dynamic mapList) {
    List<Formula> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = Formula.fromJson(mapList[i]);
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['formulaCode'] = this.formulaCode;
    data['formulaName'] = this.formulaName;
    return data;
  }
}
