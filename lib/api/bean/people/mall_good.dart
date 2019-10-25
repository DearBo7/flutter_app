class MallGoodEntity {
  String image;
  double oriPrice;
  double presentPrice;
  String goodsId;
  String goodsName;

  MallGoodEntity(
      {this.image,
      this.oriPrice,
      this.presentPrice,
      this.goodsId,
      this.goodsName});

  MallGoodEntity.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    oriPrice = json['oriPrice'];
    presentPrice = json['presentPrice'];
    goodsId = json['goodsId'];
    goodsName = json['goodsName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['oriPrice'] = this.oriPrice;
    data['presentPrice'] = this.presentPrice;
    data['goodsId'] = this.goodsId;
    data['goodsName'] = this.goodsName;
    return data;
  }
}
