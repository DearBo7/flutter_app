class MaterialBatchFormatEntity {
  int id;
  String sampleText;
  String regexStr;
  String remark;

  MaterialBatchFormatEntity({this.id,this.sampleText, this.regexStr, this.remark});

  MaterialBatchFormatEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    sampleText = json['sampleText'];
    regexStr = json['regexStr'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['sampleText'] = this.sampleText;
    data['regexStr'] = this.regexStr;
    data['remark'] = this.remark;
    return data;
  }
}
