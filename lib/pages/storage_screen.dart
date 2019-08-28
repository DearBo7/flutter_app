import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

import '../api/api_service.dart';
import '../utils/date_format.dart';

class StorageScreen extends StatefulWidget {
  @override
  _StorageScreenState createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  //with AutomaticKeepAliveClientMixin
  //字体样式
  final TextStyle _textGrey_14 = TextStyle(fontSize: 14.0, color: Colors.grey);

  //字体样式
  final TextStyle _textGrey_18 = TextStyle(fontSize: 18.0, color: Colors.grey);

  //列表数据
  final List<StoreIn> storeInList = [];

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

  void initData() async {
    startDate = formatDateShort(DateTime.now().subtract(Duration(days: 31)));
    endDate = formatDateShort(DateTime.now());

    List<ProduceLine> thisProduceLineList =
        await ApiService.getInstance().getListProduceLine();
    if (thisProduceLineList.length > 0) {
      setState(() {
        thisProduceLineList.forEach((d) => _dropdownProduceLineList.add(
            DropdownMenuItem(child: Text(d.produceLineName), value: d.id)));
      });
    }

    getStoreInList();

    List<Formula> thisFormulaList =
        await ApiService.getInstance().getListFormula();
    if (thisFormulaList.length > 0) {
      setState(() {
        thisFormulaList.forEach((d) => _dropdownFormulaList
            .add(DropdownMenuItem(child: Text(d.formulaName), value: d.id)));
      });
    }
    print("formulaList: ${thisFormulaList.length}");
  }

  //刷新
  Future<Null> _handleRefresh() async {
    getStoreInList();
    return null;
  }

  final String dateFormat = "yyyy年-MM月-dd日";

  final DateTimePickerTheme _dateTimePickerTheme = DateTimePickerTheme(
      cancel: Text("取消", style: TextStyle(color: Colors.red)),
      confirm: Text("确定", style: TextStyle(color: Colors.blue)),
      showTitle: true);

  @override
  void initState() {
    super.initState();
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
                        Text("日期:", style: _textGrey_18),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, //居中显示
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () => _clickDate(true),
                              child: Row(
                                children: <Widget>[
                                  Text(startDate, style: _textGrey_18),
                                  Icon(Icons.date_range, color: Colors.blue)
                                ],
                              ),
                            ),
                            Text("~", style: _textGrey_18),
                            InkWell(
                              onTap: () => _clickDate(false),
                              child: Row(
                                children: <Widget>[
                                  Text(endDate, style: _textGrey_18),
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
                        Text("产线:", style: _textGrey_18),
                        Expanded(
                          child: DropdownButton(
                            value: _dropdownProduceLineValue,
                            items: _dropdownProduceLineList,
                            hint: new Text('暂无产线数据...'), //当没有默认值的时候可以设置的提示
                            elevation: 24, //设置阴影的高度
                            onChanged: (value) {
                              print("ProduceLine:value:${value}");
                              setState(() {
                                _dropdownProduceLineValue = value;
                                getStoreInList();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("配方:", style: _textGrey_18),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF00C8A5), width: 0.5),
                              borderRadius: new BorderRadius.vertical(
                                  top: Radius.elliptical(3, 3),
                                  bottom: Radius.elliptical(3, 3)),
                            ),
                            child: DropdownButton(
                              value: _dropdownFormulaValue,
                              items: _dropdownFormulaList,
                              hint: new Text('暂无配方数据...'),
                              underline: Container(), //去掉下划线
                              onChanged: (value) {
                                print("Formula:value:${value}");
                                setState(() {
                                  _dropdownFormulaValue = value;
                                  getStoreInList();
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
              child: RefreshIndicator(
                displacement: 40,
                color: Colors.redAccent,
                backgroundColor: Colors.blue,
                child:
                    storeInList.isNotEmpty ? _buildListView() : Text("暂无数据..."),
                onRefresh: _handleRefresh,
              ),
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
                      Text("${storeIn.creator}", style: _textGrey_14)
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, //左右平分
                    children: <Widget>[
                      Text("${storeIn.formulaName}", style: _textGrey_14),
                      Text("${storeIn.createDate}", style: _textGrey_14)
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
    List<StoreIn> thisStoreInList = await ApiService.getInstance()
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
            getStoreInList();
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
            getStoreInList();
          }
        });
      });
    }
  }

  //list 条目点击事件
  void _clickListItem(StoreIn storeIn) {
    print("_clickListItem===>storeIn:${storeIn.id}");
  }
}
