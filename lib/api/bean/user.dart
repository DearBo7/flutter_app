class UserEntity {
  int id;
  String userName;
  String userCode;

  UserEntity({this.id, this.userName, this.userCode});

  UserEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    userName = json['userName'];
    userCode = json['userCode'];
  }

  static List<UserEntity> fromJsonList(dynamic mapList) {
    List<UserEntity> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = UserEntity.fromJson(mapList[i]);
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['userName'] = this.userName;
    data['userCode'] = this.userCode;
    return data;
  }
}
