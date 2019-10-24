class UserEntity {
  int id;
  String userName;
  String userCode;
  String department;

  UserEntity({this.id, this.userName, this.userCode, this.department});

  UserEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    userName = json['userName'];
    userCode = json['userCode'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['userName'] = this.userName;
    data['userCode'] = this.userCode;
    data['department'] = this.department;
    return data;
  }
}
