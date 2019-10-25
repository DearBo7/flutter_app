import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/widget/custom/custom_easy_refresh.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../public_index.dart';
import '../../../widget/custom/custom_empty_widget.dart';

class PeopleCategoryPage extends StatefulWidget {
  @override
  _PeopleCategoryPageState createState() => _PeopleCategoryPageState();
}

class _PeopleCategoryPageState extends State<PeopleCategoryPage> {
  List<CategoryEntity> categoryList = [];

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      _getCategoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商品分类"),
      ),
      body: Container(
        child: categoryList.isEmpty
            ? CustomListEmptyWidget(
                onRefresh: () => _getCategoryList(),
              )
            : Row(
                children: <Widget>[
                  LeftCategoryNav(categoryList: categoryList),
                  Column(
                    children: <Widget>[
                      RightCategoryNav(),
                      Expanded(
                        child: CategoryGoodList(),
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  ///查询分类数据，一级分类，二级分类
  void _getCategoryList() async {
    List<CategoryEntity> thisCategoryList =
        await PeopleApiService.getInstance().getCategoryList(context: context);
    if (thisCategoryList.length > 0) {
      CategoryEntity _categoryEntity = thisCategoryList[0];
      Store.value<CategoryModel>(context).setCategoryBxMallList(
          _categoryEntity.bxMallSubDtoList, _categoryEntity.mallCategoryId);
      setState(() {
        categoryList.addAll(thisCategoryList);
      });
    }
  }
}

///左测分类导航
class LeftCategoryNav extends StatefulWidget {
  final List<CategoryEntity> categoryList;
  final int highlightIndex;

  LeftCategoryNav({Key key, this.categoryList, this.highlightIndex: 0})
      : assert(highlightIndex != null),
        super(key: key);

  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List<CategoryEntity> _categoryList;

  int _selectCategoryIndex;

  @override
  void initState() {
    _selectCategoryIndex = widget.highlightIndex;
    _categoryList = widget.categoryList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(180),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.black12)),
      ),
      child: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return _leftInkWell(_categoryList[index], index);
        },
      ),
    );
  }

  Widget _leftInkWell(CategoryEntity categoryData, int _index) {
    return InkWell(
      onTap: () {
        if (_selectCategoryIndex != _index) {
          setState(() {
            _selectCategoryIndex = _index;
          });
          Store.value<CategoryModel>(context).setCategoryBxMallList(
              categoryData.bxMallSubDtoList, categoryData.mallCategoryId,
              context: context);
        }
      },
      child: Container(
        height: ScreenUtil.getInstance().setHeight(98),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12)),
            color: _selectCategoryIndex == _index
                ? Color.fromRGBO(244, 243, 247, 1.0)
                : Colors.white),
        child: Text(
          categoryData.mallCategoryName,
          style: TextStyles.textStyle(
              fontSize: ScreenUtil.getInstance().setSp(Dimens.font_sp28)),
        ),
      ),
    );
  }
}

///右测导航
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(98),
      width: ScreenUtil.getInstance().setWidth(900),
      child: Store.connect<CategoryModel>(builder: (context, model, child) {
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.categoryBxMallSublist.length,
            itemBuilder: (context, index) {
              return _rightInkWell(model.categoryBxMallSublist[index], index);
            });
      }),
    );
  }

  Widget _rightInkWell(CategoryBxMallSubDto categoryBxMallSubDto, int _index) {
    return InkWell(
      onTap: () {
        Store.value<CategoryModel>(context).loadGoodByCategorySubId(
            categoryBxMallSubDto.mallCategoryId, categoryBxMallSubDto.mallSubId,
            selectSecondIndex: _index, page: 1, context: context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.black12))),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          categoryBxMallSubDto.mallSubName,
          style: TextStyles.textScreenStyle(
              color: Store.value<CategoryModel>(context).secondCategoryIndex ==
                      _index
                  ? Colors.pink
                  : Colors.black,
              fontSize: Dimens.font_sp28),
        ),
      ),
    );
  }
}

///商品列表
class CategoryGoodList extends StatefulWidget {
  @override
  _CategoryGoodListState createState() => _CategoryGoodListState();
}

class _CategoryGoodListState extends State<CategoryGoodList> {
  //控制刷新组件-滚动控制器
  EasyRefreshController _refreshController;
  ScrollController _listController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    _listController = ScrollController();
  }

  @override
  void dispose() {
    if (_refreshController != null) {
      _refreshController.dispose();
    }
    if (_listController != null) {
      _listController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(900),
      margin: EdgeInsets.only(top: 5),
      child: Store.connect<CategoryModel>(builder: (context, model, child) {
        if (model.categoryGoodList.length == 0) {
          return CustomListEmptyWidget(
            emptyText: "暂无该分类商品...",
          );
        }
        //如果是第一页,滚动条滚动到顶部,hasClients必须加,反正首次会报_positions.isEmpty 异常
        if (model.firstPage &&
            _listController != null &&
            _listController.hasClients) {
          _listController.jumpTo(0.0);
        }
        return EasyRefresh(
          //控制刷新控制器
          controller: _refreshController,
          //是否开启控制结束加载
          enableControlFinishLoad: true,
          footer: CustomEasyRefresh.defaultFooter(context),
          child: ListView.builder(
            controller: _listController,
            itemCount: model.categoryGoodList.length,
            itemBuilder: (context, index) =>
                _goodItemWidget(model.categoryGoodList[index]),
          ),
          onLoad: !model.pageResult
              ? null
              : () async {
                  await Future.delayed(Duration(milliseconds: 300), () async {
                    bool resultFlag = await model.loadGoodByCategorySubId(
                        model.lastCategoryId, model.lastCategorySubId);
                    _refreshController.finishLoad();
                    if (!resultFlag) {
                      ToastUtil.show("没有更多数据.");
                    }
                  });
                },
        );
      }),
    );
  }

  Widget _goodItemWidget(MallGoodEntity mallGoodEntity) {
    return InkWell(
      onTap: () {
        ToastUtil.show(mallGoodEntity.goodsName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: <Widget>[
            _getGoodImages(mallGoodEntity.image),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getGoodName(mallGoodEntity.goodsName),
                    _getPrice(
                        mallGoodEntity.presentPrice, mallGoodEntity.oriPrice),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //商品图片
  Widget _getGoodImages(String url) {
    return Container(
      width: ScreenUtil().setWidth(200),
      alignment: Alignment.center,
      child: Image.network(url),
    );
  }

  //商品名称
  Widget _getGoodName(String goodsName) {
    return Container(
      child: Text(
        goodsName,
        style: TextStyles.textScreenStyle(fontSize: Dimens.font_sp28),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  //价格
  Widget _getPrice(double presentPrice, double oriPrice) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Text(
            "价格：￥$presentPrice",
            style: TextStyles.textScreenStyle(
                fontSize: Dimens.font_sp30, color: Colors.pink),
          ),
          Gaps.wGap10,
          Text(
            "￥$oriPrice",
            style: TextStyles.textScreenStyle(
                fontSize: Dimens.font_sp26,
                decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }
}
