import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../public_index.dart';
import '../../widget/custom/custom_easy_refresh.dart';
import '../../widget/custom/custom_empty_widget.dart';
import '../../widget/custom/custom_widgets.dart';
import 'material_page.dart';
import '../src/app_bar_preferred.dart';

class StoragePage extends StatefulWidget {
  @override
  _StoragePageState createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  //列表数据
  final List<StoreInEntity> _storeInList = [];

  //产线
  final List<DropdownMenuItem<int>> _dropdownProduceLineList = [];
  int _dropdownProduceLineValue = -1; //选中的产线id

  //配方
  final List<DropdownMenuItem<int>> _dropdownFormulaList = [];
  int _dropdownFormulaValue = -1; //选中的配方id

  final String _dateFormat = "yyyy年-MM月-dd日";

  //开始日期
  String startDate;

  //结束日期
  String endDate;

  DateTimePickerTheme _dateTimePickerTheme;

  //控制刷新组件-滚动控制器
  EasyRefreshController _refreshController;

  void initView() {
    _refreshController = EasyRefreshController();
    _dateTimePickerTheme = DateTimePickerTheme(
        cancel: Text("取消", style: TextStyle(color: Colors.red)),
        confirm: Text("确定", style: TextStyle(color: Colors.blue)),
        showTitle: true);
  }

  @override
  void initState() {
    super.initState();
    //初始化组件
    initView();
    //加载数据
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPreferred.getPreferredSize(context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                RowLabelToWidgetOne(
                  Text(S.of(context).dateTitle, style: TextStyles.labelTitle),
                  rightWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*InkWell(
                        onTap: () {
                          var loadingDialog = CustomizeLoadingDialog(context)
                              .show(
                                  isShowText: true,
                                  delay: Duration(milliseconds: 120),
                                  showWidget: SpinKitWave(
                                      color: Theme.of(context).accentColor));
                          //loadingDialog.hide();
                          Timer(Duration(milliseconds: 2000),
                              () => loadingDialog.hide());
                        },
                        child: Icon(Icons.add),
                      ),*/
                      InkWell(
                        onTap: () => _clickDate(true),
                        child: Row(
                          children: <Widget>[
                            Text(startDate, style: TextStyles.labelTitle),
                            Icon(Icons.date_range, color: Colors.blue)
                          ],
                        ),
                      ),
                      Text("~", style: TextStyles.labelTitle),
                      InkWell(
                        onTap: () => _clickDate(false),
                        child: Row(
                          children: <Widget>[
                            Text(endDate, style: TextStyles.labelTitle),
                            Icon(Icons.date_range, color: Colors.blue)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                RowLabelToWidgetOne(
                  Text(S.of(context).produceLineTitle,
                      style: TextStyles.labelTitle),
                  margin: EdgeInsets.symmetric(vertical: 2.5),
                  rightWidget: Container(
                    height: Dimens.dropdownButtonHeight,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400], width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _dropdownProduceLineValue,
                        items: _dropdownProduceLineList,
                        disabledHint: Text(S.of(context).noDataProduceLine),
                        //isDense: true,
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            if (_dropdownProduceLineValue != value) {
                              _dropdownProduceLineValue = value;
                              _refreshController.callRefresh();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                RowLabelToWidgetOne(
                  Text(S.of(context).formulaTitle,
                      style: TextStyles.labelTitle),
                  margin: EdgeInsets.symmetric(vertical: 2.5),
                  rightWidget: Container(
                    height: Dimens.dropdownButtonHeight,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400], width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _dropdownFormulaValue,
                        items: _dropdownFormulaList,
                        disabledHint: Text(S.of(context).noDataFormula),
                        //isDense: true,
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            if (_dropdownFormulaValue != value) {
                              _dropdownFormulaValue = value;
                              _refreshController.callRefresh();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: EasyRefresh(
              //是否首次刷新
              firstRefresh: true,
              firstRefreshWidget:
              CustomEasyRefresh.defaultFirstRefreshWidget(context),
              //是否开启控制结束刷新
              enableControlFinishRefresh: true,
              //控制刷新控制器
              controller: _refreshController,
              emptyWidget:
              _storeInList.isEmpty ? CustomListEmptyWidget() : null,
              //底部回弹,默认true
              bottomBouncing: false,
              child: _buildListView(),
              header: CustomEasyRefresh.defaultClassicalHeader(context),
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 300), () {
                  getStoreInList();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  //构建显示列表
  Widget _buildListView() {
    return ListView.separated(
      itemCount: _storeInList.length,
      itemBuilder: (context, index) {
        var storeIn = _storeInList[index];
        return InkWell(
            onTap: () => _clickListItem(storeIn),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${storeIn.billCode}-${storeIn.produceLineName}",
                          style: TextStyles.listTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text("${storeIn.creator}", style: TextStyles.listSubtitle)
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //左右平分
                    children: <Widget>[
                      Text("${storeIn.formulaName}",
                          style: TextStyles.listSubtitle),
                      Text("${storeIn.createDate}",
                          style: TextStyles.listSubtitle)
                    ],
                  )
                ],
              ),
            ));
      },
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 2.0),
    );
  }

  //list 条目点击事件
  void _clickListItem(StoreInEntity storeIn) async {
    //异步方式
    /*Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MaterialPage(storeIn: storeIn)))
        .then((result) {
      if (result != null) {
        ToastUtil.show("异步方式-返回结果:$result");
      }
    }).catchError((error) {
      print("error===>$error");
    });*/
    RouteUtils.pushRouteNameNewPage(context, RouteName.material,
        arguments: storeIn, callBack: (result) {
          if (result is bool) {
            if (result) {
              if (_refreshController != null) {
                _refreshController.callRefresh();
              } else {
                getStoreInList();
              }
            }
          }
          //ToastUtil.show("异步方式-返回结果:$result");
        });
  }

  //获取列表数据
  getStoreInList() async {
    List<StoreInEntity> thisStoreInList = await ApiService.getInstance()
        .getListStoreIn(startDate, endDate,
        produceLineId: _dropdownProduceLineValue,
        formulaId: _dropdownFormulaValue);
    setState(() {
      if (_storeInList.length > 0) {
        _storeInList.clear();
      }
      if (thisStoreInList.length > 0) {
        _storeInList.addAll(thisStoreInList);
      }
    });
    if (_refreshController != null) {
      _refreshController.resetLoadState();
      _refreshController.finishRefresh();
    }
  }

  //日期点击事件
  void _clickDate(statusFlag) {
    if (statusFlag) {
      //开始日期
      DatePicker.showDatePicker(context,
          minDateTime: DateTime.parse("2000-01-01"),
          maxDateTime: DateTime.parse(endDate),
          initialDateTime: DateTime.parse(startDate),
          dateFormat: _dateFormat,
          locale: DateTimePickerLocale.zh_cn,
          pickerTheme: _dateTimePickerTheme,
          onConfirm: (dateTime, List<int> index) {
            setState(() {
              String strDate =
              DateUtil.formatDate(dateTime, format: DataFormats.y_mo_d);
              if (strDate != startDate) {
                startDate =
                    DateUtil.formatDate(dateTime, format: DataFormats.y_mo_d);
                _refreshController.callRefresh();
              }
            });
          });
    } else {
      //结束日期
      DatePicker.showDatePicker(context,
          minDateTime: DateTime.parse(startDate),
          maxDateTime: DateTime.now(),
          initialDateTime: DateTime.parse(endDate),
          dateFormat: _dateFormat,
          locale: DateTimePickerLocale.zh_cn,
          pickerTheme: _dateTimePickerTheme,
          onConfirm: (dateTime, List<int> index) {
            setState(() {
              String strDate =
              DateUtil.formatDate(dateTime, format: DataFormats.y_mo_d);
              if (strDate != endDate) {
                endDate = DateUtil.formatDate(dateTime, format: DataFormats.y_mo_d);
                _refreshController.callRefresh();
              }
            });
          });
    }
  }

  void initData() {
    startDate = DateUtil.formatDate(DateTime.now().subtract(Duration(days: 30)),
        format: DataFormats.y_mo_d);
    endDate = DateUtil.formatDate(DateTime.now(), format: DataFormats.y_mo_d);
    _dropdownFormulaList.add(DropdownMenuItem(child: Text("-全部-"), value: -1));
    _dropdownProduceLineList
        .add(DropdownMenuItem(child: Text("-全部-"), value: -1));
    getProduceLineList();
    getFormulaList();
  }

  void getProduceLineList() async {
    List<ProduceLineEntity> thisProduceLineList =
    await ApiService.getInstance().getListProduceLine();
    if (thisProduceLineList.length > 0) {
      setState(() {
        _dropdownProduceLineList.addAll(thisProduceLineList
            .map((item) => DropdownMenuItem(
            child: Text(item.produceLineName), value: item.id))
            .toList());
      });
    }
  }

  void getFormulaList() async {
    List<FormulaEntity> thisFormulaList =
    await ApiService.getInstance().getListFormula();
    if (thisFormulaList.length > 0) {
      setState(() {
        _dropdownFormulaList.addAll(thisFormulaList
            .map((item) =>
            DropdownMenuItem(child: Text(item.formulaName), value: item.id))
            .toList());
      });
    }
  }
}
