import 'package:flutter/material.dart';

import '../api/api_service.dart';

class StorageScreen extends StatefulWidget {
  @override
  _StorageScreenState createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  //with AutomaticKeepAliveClientMixin
  final List<StoreIn> storeInList = [];

  final TextStyle _textGrey_14 = TextStyle(fontSize: 14.0, color: Colors.grey);
  final TextStyle _textGrey_18 = TextStyle(fontSize: 18.0, color: Colors.grey);

  void initData() async {
    List<ProduceLine> produceLineList =
        await ApiService.getInstance().getListProduceLine();
    print("produceLineList: ${produceLineList.length}");

    List<Formula> formulaList = await ApiService.getInstance().getListFormula();
    print("formulaList: ${formulaList.length}");
    List<StoreIn> thisStoreInList = await ApiService.getInstance()
        .getListStoreIn("2018-08-27", "2019-08-27", context: context);
    print("storeInList: ${storeInList.length}");
    if (thisStoreInList.length > 0) {
      setState(() {
        storeInList.addAll(thisStoreInList);
      });
    }
  }

  //刷新
  Future<Null> _handleRefresh() async {
    List<StoreIn> thisStoreInList = await ApiService.getInstance()
        .getListStoreIn("2018-08-27", "2019-08-27");
    setState(() {
      //storeInList.clear();
      if (thisStoreInList.length > 0) {
        storeInList.addAll(thisStoreInList);
      }
    });

    return null;
  }

  void _clickTime(statusFlag) {
    print("_clickTime===>statusFlag:${statusFlag}");
  }

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
        appBar: AppBar(
          title: Text("入库"),
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("日期:"),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, //居中显示
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () => _clickTime(true),
                              child: Row(
                                children: <Widget>[
                                  Text("2019-07-27", style: _textGrey_18),
                                  Icon(Icons.date_range, color: Colors.blue)
                                ],
                              ),
                            ),
                            Text("~", style: _textGrey_18),
                            InkWell(
                              onTap: () => _clickTime(false),
                              child: Row(
                                children: <Widget>[
                                  Text("2019-08-27", style: _textGrey_18),
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
                          child: Text("产线占剩下全部..."),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("配方:", style: _textGrey_18),
                        Expanded(
                          child: Text("配方占剩下全部..."),
                        )
                      ],
                    ),
                  ],
                )),
            Expanded(
              child: RefreshIndicator(
                displacement: 50,
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

  Widget _buildListView() {
    return ListView.separated(
      //padding: const EdgeInsets.all(16.0),
      itemCount: storeInList.length,
      itemBuilder: (context, index) {
        var storeIn = storeInList[index];
        return Container(
          padding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${storeIn.billCode}-${storeIn.produceLineName}",
                      style: TextStyle(fontSize: 18.0, color: Colors.black)),
                  Text("${storeIn.creator}", style: _textGrey_14)
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, //左右平分
                children: <Widget>[
                  Text("${storeIn.formulaName}", style: _textGrey_14),
                  Text("${storeIn.createDate}", style: _textGrey_14)
                ],
              )
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
}
