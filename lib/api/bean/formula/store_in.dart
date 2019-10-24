class StoreInEntity {
  String formulaName;
  String creator;
  String billCode;
  int id;
  String produceLineName;
  String createDate;

  StoreInEntity(
      {this.formulaName,
      this.creator,
      this.billCode,
      this.id,
      this.produceLineName,
      this.createDate});

  StoreInEntity.fromJson(Map<String, dynamic> json) {
    formulaName = json['formulaName'];
    creator = json['creator'];
    billCode = json['billCode'];
    id = json['Id'];
    produceLineName = json['produceLineName'];
    createDate = json['createDate'];
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
