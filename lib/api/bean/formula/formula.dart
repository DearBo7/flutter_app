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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['formulaCode'] = this.formulaCode;
    data['formulaName'] = this.formulaName;
    return data;
  }
}
