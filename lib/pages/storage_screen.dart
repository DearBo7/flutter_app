import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './src/text_style_util.dart';
import '../api/api_service.dart';
import '../utils/date_format.dart';

class StorageScreen extends StatefulWidget {
  @override
  _StorageScreenState createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  //with AutomaticKeepAliveClientMixin

  //列表数据
  final List<StoreInEntity> storeInList = [];

  //产线
  final List<DropdownMenuItem<int>> _dropdownProduceLineList = [
    DropdownMenuItem(
      child: Text("-全部-"),
      value: -1,
    )
  ];
  int _dropdownProduceLineValue = -1;

  //配方
  final List<DropdownMenuItem<int>> _dropdownFormulaList = [
    DropdownMenuItem(
      child: Text("-全部-"),
      value: -1,
    )
  ];
  int _dropdownFormulaValue = -1;

  //日期
  String startDate;
  String endDate;

  //控制刷新组件-滚动控制器
  EasyRefreshController _controller;

  void initView() {
    _controller = EasyRefreshController();
  }

  void initData() async {
    startDate = formatDateShort(DateTime.now().subtract(Duration(days: 31)));
    endDate = formatDateShort(DateTime.now());

    List<ProduceLineEntity> thisProduceLineList =
        await ApiService.getInstance().getListProduceLine();
    if (thisProduceLineList.length > 0) {
      setState(() {
        thisProduceLineList.forEach((d) => _dropdownProduceLineList.add(
            DropdownMenuItem(child: Text(d.produceLineName), value: d.id)));
      });
    }

    getStoreInList();

    List<FormulaEntity> thisFormulaList =
        await ApiService.getInstance().getListFormula();
    if (thisFormulaList.length > 0) {
      setState(() {
        thisFormulaList.forEach((d) => _dropdownFormulaList
            .add(DropdownMenuItem(child: Text(d.formulaName), value: d.id)));
      });
    }
    print("formulaList: ${thisFormulaList.length}");
  }

  final String dateFormat = "yyyy年-MM月-dd日";

  final DateTimePickerTheme _dateTimePickerTheme = DateTimePickerTheme(
      cancel: Text("取消", style: TextStyle(color: Colors.red)),
      confirm: Text("确定", style: TextStyle(color: Colors.blue)),
      showTitle: true);

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
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context, 'dateTitle'),
                            style: textGrey_18),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, //居中显示
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () => _clickDate(true),
                              child: Row(
                                children: <Widget>[
                                  Text(startDate, style: textGrey_18),
                                  Icon(Icons.date_range, color: Colors.blue)
                                ],
                              ),
                            ),
                            Text("~", style: textGrey_18),
                            InkWell(
                              onTap: () => _clickDate(false),
                              child: Row(
                                children: <Widget>[
                                  Text(endDate, style: textGrey_18),
                                  Icon(Icons.date_range, color: Colors.blue)
                                ],
                              ),
                            )
                          ],
                        ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context, 'produceLineTitle'),
                            style: textGrey_18),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            margin: EdgeInsets.only(top: 2.5, bottom: 2.5),
                            height: 35.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey[400], width: 0.5),
                              borderRadius: new BorderRadius.vertical(
                                  top: Radius.elliptical(3, 3),
                                  bottom: Radius.elliptical(3, 3)),
                            ),
                            child: DropdownButton(
                              value: _dropdownProduceLineValue,
                              items: _dropdownProduceLineList,
                              hint: new Text(FlutterI18n.translate(context,
                                  'noDataProduceLine')), //当没有默认值的时候可以设置的提示
                              underline: Container(),
                              onChanged: (value) {
                                print("ProduceLine:value:${value}");
                                setState(() {
                                  _dropdownProduceLineValue = value;
                                  _controller.callRefresh();
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context, 'formulaTitle'),
                            style: textGrey_18),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            margin: EdgeInsets.only(top: 2.5, bottom: 2.5),
                            height: 35.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey[400], width: 0.5),
                              borderRadius: new BorderRadius.vertical(
                                  top: Radius.elliptical(3, 3),
                                  bottom: Radius.elliptical(3, 3)),
                            ),
                            child: DropdownButton(
                              value: _dropdownFormulaValue,
                              items: _dropdownFormulaList,
                              hint: new Text(FlutterI18n.translate(
                                  context, 'noDataFormula')),
                              underline: Container(), //去掉下划线
                              onChanged: (value) {
                                print("Formula:value:${value}");
                                setState(() {
                                  _dropdownFormulaValue = value;
                                  _controller.callRefresh();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Expanded(
              child: EasyRefresh(
                firstRefresh: true, //是否首次刷新
                firstRefreshWidget: _firstRefreshWidget(),
                enableControlFinishRefresh: true, //是否开启控制结束刷新
                controller: _controller, //控制刷新控制器
                emptyWidget: storeInList.isEmpty ? _emptyWidget() : null,
                bottomBouncing: false, //底部回弹,默认true
                child: _buildListView(),
                header: ClassicalHeader(
                  enableHapticFeedback: true, //开启震动反馈,
                  float: true, //是否浮动
                  refreshText: FlutterI18n.translate(context, 'pullToRefresh'),
                  refreshReadyText:
                      FlutterI18n.translate(context, 'releaseToRefresh'),
                  refreshingText: FlutterI18n.translate(context, 'refreshing'),
                  refreshedText: FlutterI18n.translate(context, 'refreshed'),
                  refreshFailedText:
                      FlutterI18n.translate(context, 'refreshFailed'),
                  noMoreText: FlutterI18n.translate(context, 'noMore'),
                  infoText: FlutterI18n.translate(context, 'updateAt'),
                  textColor: Colors.white,
                  bgColor: Colors.black87,
                  infoColor: Colors.white70,
                ),
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1), () {
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

  //构建显示列表
  Widget _buildListView() {
    return ListView.separated(
      itemCount: storeInList.length,
      itemBuilder: (context, index) {
        var storeIn = storeInList[index];
        return InkWell(
            onTap: () => _clickListItem(storeIn),
            child: Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("${storeIn.billCode}-${storeIn.produceLineName}",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black)),
                      Text("${storeIn.creator}", style: textGrey_14)
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //左右平分
                    children: <Widget>[
                      Text("${storeIn.formulaName}", style: textGrey_14),
                      Text("${storeIn.createDate}", style: textGrey_14)
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

  //加载组件
  Widget _firstRefreshWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
          child: SizedBox(
        height: 200.0,
        width: 300.0,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                child: SpinKitFadingCube(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              ),
              Container(
                child: Text(FlutterI18n.translate(context, 'loading')),
              )
            ],
          ),
        ),
      )),
    );
  }

  //空列表显示Widget
  Widget _emptyWidget() {
    return Container(
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: Image.asset('assets/images/empty.jpeg'),
          ),
          Text(
            FlutterI18n.translate(context, 'noData'),
            style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
          ),
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
        ],
      ),
    );
  }

  //获取列表数据
  getStoreInList() async {
    List<StoreInEntity> thisStoreInList = await ApiService.getInstance()
        .getListStoreIn(startDate, endDate,
            produceLineId: _dropdownProduceLineValue,
            formulaId: _dropdownFormulaValue,
            context: context);
    if (thisStoreInList.length > 0) {
      setState(() {
        if (storeInList.length > 0) {
          storeInList.clear();
        }
        storeInList.addAll(thisStoreInList);
      });
    }
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
          dateFormat: dateFormat,
          locale: DateTimePickerLocale.zh_cn,
          pickerTheme: _dateTimePickerTheme,
          onConfirm: (dateTime, List<int> index) {
        setState(() {
          String strDate = formatDateShort(dateTime);
          if (strDate != startDate) {
            startDate = formatDateShort(dateTime);
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
          dateFormat: dateFormat,
          locale: DateTimePickerLocale.zh_cn,
          pickerTheme: _dateTimePickerTheme,
          onConfirm: (dateTime, List<int> index) {
        setState(() {
          String strDate = formatDateShort(dateTime);
          if (strDate != endDate) {
            endDate = formatDateShort(dateTime);
            _controller.callRefresh();
          }
        });
      });
    }
  }

  //list 条目点击事件
  void _clickListItem(StoreInEntity storeIn) {
    print("_clickListItem===>storeIn:${storeIn.id}");
  }
}
