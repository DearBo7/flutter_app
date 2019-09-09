import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../public_index.dart';
import '../../store/enums/enum_index.dart';
import '../widget/input/spinner_input.dart';
//import 'package:spinner_input/spinner_input.dart';

class SettingPage extends StatelessWidget {
  final List<EnumEntity> matchedPatternList = EnumEntity.toMatchedPatternList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).setting),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text("识别设置", style: TextStyles.text12)),
              SizedBox(height: 5, child: Divider(height: 1)),
              Material(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("图片质量(20-100):", style: TextStyles.text16),
                  trailing: SpinnerInput(
                    spinnerValue: Store.value<SettingModel>(context).quality,
                    minValue: 20,
                    maxValue: 100,
                    //disabledLongPress: true,
                    //disabledPopup: false,//禁用点击
                    onChange: (newValue) {
                      Store.value<SettingModel>(context)
                          .setQuality(newValue.toInt());
                    },
                  ),
                ),
              ),
              SizedBox(height: 5, child: Divider(height: 1)),
              Material(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("匹配相似度(1-100):", style: TextStyles.text16),
                  trailing: SpinnerInput(
                    spinnerValue: Store.value<SettingModel>(context).similarity,
                    minValue: 1,
                    maxValue: 100,
                    onChange: (newValue) {
                      Store.value<SettingModel>(context)
                          .setSimilarity(newValue.toInt());
                    },
                  ),
                ),
              ),
              SizedBox(height: 5, child: Divider(height: 1)),
              Material(
                color: Theme.of(context).cardColor,
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("匹配模式:", style: TextStyles.text16),
                      Text(
                          getMatchedPatternLabel(
                              Store.value<SettingModel>(context)
                                  .matchedPattern),
                          style: TextStyles.text16)
                    ],
                  ),
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: matchedPatternList.length,
                        itemBuilder: (context, index) {
                          SettingModel model =
                              Store.value<SettingModel>(context);
                          return RadioListTile(
                            value: index,
                            onChanged: (index) {
                              model.setMatchedPattern(
                                  matchedPatternList[index].index);
                            },
                            groupValue: model.matchedPattern,
                            title: Text(matchedPatternList[index].label,
                                style: TextStyles.text16),
                          );
                        })
                  ],
                ),
              ),
              SizedBox(height: 5, child: Divider(height: 1)),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text("打印设置", style: TextStyles.text12)),
              SizedBox(height: 5, child: Divider(height: 1)),
              Material(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("蓝牙默认名称", style: TextStyles.text16),
                  trailing: Text(Store.value<PrintModel>(context).bluetoothName,
                      style: TextStyles.text16),
                ),
              ),
              SizedBox(height: 5, child: Divider(height: 1)),
              Material(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("打印标签", style: TextStyles.text16),
                  trailing: CupertinoSwitch(
                      value: Store.value<PrintModel>(context).printAutoFlag,
                      onChanged: (value) {
                        Store.value<PrintModel>(context)
                            .setPrintAutoFlag(value);
                      }),
                ),
              ),
              SizedBox(height: 5, child: Divider(height: 1)),
              Material(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  onTap: () {
                    Toast.show(context, "打印测试...");
                  },
                  title: Text("打印测试", style: TextStyles.text16),
                ),
              ),
              SizedBox(height: 5, child: Divider(height: 1)),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text("其他设置", style: TextStyles.text12)),
              SizedBox(height: 5, child: Divider(height: 1)),
              Material(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("显示批次规则", style: TextStyles.text16),
                  trailing: CupertinoSwitch(
                      value: Store.value<SettingModel>(context)
                          .materialBatchShowFlag,
                      onChanged: (value) {
                        Store.value<SettingModel>(context)
                            .setMaterialBatchShowFlag(value);
                      }),
                ),
              ),
              SizedBox(height: 5, child: Divider(height: 1)),
              Material(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("区分大小写", style: TextStyles.text16),
                  trailing: CupertinoSwitch(
                      value: Store.value<SettingModel>(context)
                          .materialOrcCaseFlag,
                      onChanged: (value) {
                        Store.value<SettingModel>(context)
                            .setMaterialOrcCaseFlag(value);
                      }),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  String getMatchedPatternLabel(int keyIndex) {
    for (var item in matchedPatternList) {
      if (item.index == keyIndex) {
        return item.label;
      }
    }
    return "";
  }
}
