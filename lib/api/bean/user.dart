class User {
  int id;
  String userName;
  String userCode;

  User({this.id, this.userName, this.userCode});

  User.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    userName = json['userName'];
    userCode = json['userCode'];
  }

  static List<User> fromJsonList(dynamic mapList) {
    List<User> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = User.fromJson(mapList[i]);
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
