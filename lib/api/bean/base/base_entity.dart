abstract class BaseEntity<T> {
  List<T> fromMapList(dynamic mapList) {
    List<T> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromJson(mapList[i]);
    }
    return list;
  }

  T fromJson(Map<String, dynamic> json);
}
