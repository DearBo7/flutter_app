import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart';
import 'package:flutter_app/public_index.dart';

import '../../../api/bean/people/category.dart';

///分类Model
class CategoryModel with ChangeNotifier {
  //二级分类
  List<CategoryBxMallSubDto> categoryBxMallSublist = [];

  //二级分类索引
  int secondCategoryIndex = 0;

  //分类商品
  List<MallGoodEntity> categoryGoodList = [];

  //加载数据页
  int _page = 1;

  //获取是否第一页
  bool firstPage = true;

  //最后一次加载的一级分类
  String lastCategoryId;

  //最后一次加载的二级分类
  String lastCategorySubId;

  //页加载数据是否成功
  bool pageResult = true;

  //设置二级分类数据-切换一级分类时
  void setCategoryBxMallList(
      List<CategoryBxMallSubDto> _categoryBxMallSublist, String mallCategoryId,
      {BuildContext context}) async {
    categoryBxMallSublist = [
      CategoryBxMallSubDto(
          mallSubName: "全部",
          mallSubId: "",
          mallCategoryId: mallCategoryId,
          comments: null)
    ];
    if (ObjectUtils.isNotEmpty(_categoryBxMallSublist)) {
      categoryBxMallSublist.addAll(_categoryBxMallSublist);
    }
    //每次切换二级分类索引设置为0
    secondCategoryIndex = 0;
    //加载页数设置为1
    _page = 1;
    await _getCategoryGoodList(mallCategoryId, context: context);
    notifyListeners();
  }

  //加载数据-可根据分类和二级分类,初始加载page=0
  Future<bool> loadGoodByCategorySubId(String categoryId, String categorySubId,
      {int selectSecondIndex, int page, BuildContext context}) async {
    if (selectSecondIndex != null && selectSecondIndex > -1) {
      //切换二级分类索引
      secondCategoryIndex = selectSecondIndex;
    }
    if (page != null && page > 0) {
      _page = page;
    }
    bool result = await _getCategoryGoodList(categoryId,
        categorySubId: categorySubId, context: context);
    notifyListeners();
    return result;
  }

  //请求商品数据
  Future<bool> _getCategoryGoodList(String categoryId,
      {String categorySubId, BuildContext context}) async {
    List<MallGoodEntity> thisCategoryGoodList =
        await PeopleApiService.getInstance().getMallGoodByCategoryList(
            _page++, categoryId,
            categorySubId: categorySubId, context: context);
    //记录最后一次分类查询
    this.lastCategoryId = categoryId;
    this.lastCategorySubId = categorySubId;
    //因为已经++了,所以为2时,只加载了第一条
    if (_page == 2) {
      firstPage = true;
      if (categoryGoodList.length > 0) {
        categoryGoodList.clear();
      }
    } else {
      firstPage = false;
    }
    if (thisCategoryGoodList.length > 0) {
      categoryGoodList.addAll(thisCategoryGoodList);
      pageResult = true;
    } else {
      pageResult = false;
      _page--;
    }
    return pageResult;
  }
}
