import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../public_index.dart';
import '../../../store/enums/enum_index.dart';
import '../../widget/input_text/spinner_input.dart';
//import 'package:spinner_input/spinner_input.dart';

class FormulaSettingPage extends StatelessWidget {
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
                  margin: EdgeInsets.symmetric(vertical: 2.5),
                  alignment: Alignment.centerLeft,
                  child: Text("识别设置", style: TextStyles.settingGroupTitle)),
              Dividers.setDivider(),
              Container(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("图片质量(20-100):", style: TextStyles.settingTitle),
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
              Dividers.setDivider(),
              Container(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("匹配相似度(1-100):", style: TextStyles.settingTitle),
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
              Dividers.setDivider(),
              Container(
                color: Theme.of(context).cardColor,
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("匹配模式:", style: TextStyles.settingTitle),
                      Text(
                          getMatchedPatternLabel(
                              Store.value<SettingModel>(context)
                                  .matchedPattern),
                          style: TextStyles.settingTitle)
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
                                  matchedPatternList[index].code);
                            },
                            groupValue: model.matchedPattern,
                            title: Text(matchedPatternList[index].label,
                                style: TextStyles.settingTitle),
                          );
                        })
                  ],
                ),
              ),
              Dividers.setDivider(),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 2.5),
                  alignment: Alignment.centerLeft,
                  child: Text("打印设置", style: TextStyles.settingGroupTitle)),
              Dividers.setDivider(),
              Container(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("蓝牙默认名称", style: TextStyles.settingTitle),
                  trailing: Text(Store.value<PrintModel>(context).bluetoothName,
                      style: TextStyles.settingTitle),
                ),
              ),
              Dividers.setDivider(),
              Container(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("打印标签", style: TextStyles.settingTitle),
                  trailing: CupertinoSwitch(
                      value: Store.value<PrintModel>(context).printAutoFlag,
                      onChanged: (value) {
                        Store.value<PrintModel>(context)
                            .setPrintAutoFlag(value);
                      }),
                ),
              ),
              Dividers.setDivider(),
              Container(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  onTap: () {
                    ToastUtil.show("打印测试...");
                  },
                  title: Text("打印测试", style: TextStyles.settingTitle),
                ),
              ),
              Dividers.setDivider(),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 2.5),
                  alignment: Alignment.centerLeft,
                  child: Text("其他设置", style: TextStyles.settingGroupTitle)),
              Dividers.setDivider(),
              Container(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("显示批次规则", style: TextStyles.settingTitle),
                  trailing: CupertinoSwitch(
                      value: Store.value<SettingModel>(context)
                          .materialBatchShowFlag,
                      onChanged: (value) {
                        Store.value<SettingModel>(context)
                            .setMaterialBatchShowFlag(value);
                      }),
                ),
              ),
              Dividers.setDivider(),
              Container(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text("区分大小写", style: TextStyles.settingTitle),
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
      if (item.code == keyIndex) {
        return item.label;
      }
    }
    return "";
  }
}
