import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../public_index.dart';
import '../widget/customize_easy_refresh.dart';
import '../widget/customize_widgets.dart';
import '../widget/empty/empty_list_widget.dart';
import 'material_page.dart';
import 'src/app_bar_preferred.dart';

class StorageScreen extends StatefulWidget {
  @override
  _StorageScreenState createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
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
  EasyRefreshController _controller;

  void initView() {
    _controller = EasyRefreshController();
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

  //默认是false-不保存页面状态
  //@override
  //bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPreferred.getPreferredSize(context),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    RowLabelToWidgetOne(
                      Text(S.of(context).dateTitle,
                          style: TextStyles.labelTitle),
                      rightWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          /*InkWell(
                            onTap: () {
                              var loadingDialog =
                                  CustomizeLoadingDialog(context)
                                      .show(isShowText: true);
                              //loadingDialog.hide();
                              Timer(Duration(seconds: 2),
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
                      rightWidget: Container(
                        height: 35,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[400], width: 0.5),
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
                                  _controller.callRefresh();
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
                      rightWidget: Container(
                        height: 35,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[400], width: 0.5),
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
                                  _controller.callRefresh();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: EasyRefresh(
                firstRefresh: true,
                //是否首次刷新
                firstRefreshWidget:
                    CustomizeEasyRefresh.defaultFirstRefreshWidget(context),
                enableControlFinishRefresh: true,
                //是否开启控制结束刷新
                controller: _controller,
                //控制刷新控制器
                emptyWidget: _storeInList.isEmpty ? EmptyListWidget() : null,
                bottomBouncing: false,
                //底部回弹,默认true
                child: _buildListView(),
                header: CustomizeEasyRefresh.defaultClassicalHeader(context),
                onRefresh: () async {
                  await Future.delayed(Duration(milliseconds: 300), () {
                    getStoreInList();
                  });
                },
              ),
              /*child: RefreshIndicator(
                displacement: 40,
                color: Colors.redAccent,
                backgroundColor: Colors.blue,
                child:
                    storeInList.isNotEmpty ? _buildListView() : Text("暂无数据..."),
                onRefresh: _handleRefresh,
              ),*/
            )
          ],
        ));
  }

  //list 条目点击事件
  void _clickListItem(StoreInEntity storeIn) async {
    //同步方式
    /*final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MaterialPage(storeIn: storeIn)));
    if (result != null) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("返回结果:$result")));
    }*/
    //异步方式
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MaterialPage(storeIn: storeIn)))
        .then((result) {
      if (result != null) {
        ToastUtil.show("异步方式-返回结果:$result");
      }
    }).catchError((error) {
      print("error===>$error");
    });
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
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("${storeIn.billCode}-${storeIn.produceLineName}",
                          style: TextStyles.listTitle),
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

    _controller.resetLoadState();
    _controller.finishRefresh();
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
            _controller.callRefresh();
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
            _controller.callRefresh();
          }
        });
      });
    }
  }

  void initData() {
    startDate = DateUtil.formatDate(
        DateTime.now().subtract(Duration(days: 31 * 3)),
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
