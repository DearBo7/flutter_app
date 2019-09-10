import 'base/input_select_entity.dart';

class UserEntity extends InputSelectEntity {
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
    data['department'] = this.department;
    return data;
  }

  @override
  String getShowLabel() {
    return this.userName;
  }

  @override
  String getShowValue() {
    return this.userCode;
  }
}
