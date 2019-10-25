class CategoryEntity {
  List<CategoryBxMallSubDto> bxMallSubDtoList;
  String mallCategoryId;
  String mallCategoryName;

  CategoryEntity(
      {this.bxMallSubDtoList, this.mallCategoryId, this.mallCategoryName});

  CategoryEntity.fromJson(Map<String, dynamic> json) {
    if (json['bxMallSubDto'] != null) {
      bxMallSubDtoList = new List<CategoryBxMallSubDto>();
      (json['bxMallSubDto'] as List).forEach((v) {
        bxMallSubDtoList.add(new CategoryBxMallSubDto.fromJson(v));
      });
    }
    mallCategoryId = json['mallCategoryId'];
    mallCategoryName = json['mallCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bxMallSubDtoList != null) {
      data['bxMallSubDto'] = this.bxMallSubDtoList.map((v) => v.toJson()).toList();
    }
    data['mallCategoryId'] = this.mallCategoryId;
    data['mallCategoryName'] = this.mallCategoryName;
    return data;
  }
}

class CategoryBxMallSubDto {
  String mallSubName;
  String comments;
  String mallCategoryId;
  String mallSubId;

  CategoryBxMallSubDto(
      {this.mallSubName, this.comments, this.mallCategoryId, this.mallSubId});

  CategoryBxMallSubDto.fromJson(Map<String, dynamic> json) {
    mallSubName = json['mallSubName'];
    comments = json['comments'];
    mallCategoryId = json['mallCategoryId'];
    mallSubId = json['mallSubId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mallSubName'] = this.mallSubName;
    data['comments'] = this.comments;
    data['mallCategoryId'] = this.mallCategoryId;
    data['mallSubId'] = this.mallSubId;
    return data;
  }
}
