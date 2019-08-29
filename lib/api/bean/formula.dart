class FormulaEntity {
  int id;
  String formulaCode;
  String formulaName;

  FormulaEntity({this.id, this.formulaCode, this.formulaName});

  FormulaEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    formulaCode = json['formulaCode'];
    formulaName = json['formulaName'];
  }

  static List<FormulaEntity> fromJsonList(dynamic mapList) {
    List<FormulaEntity> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = FormulaEntity.fromJson(mapList[i]);
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
