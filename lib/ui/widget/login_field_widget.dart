import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/i18n.dart';

/*class LoginSelectUser<T extends InputSelectEntity> extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<T> items;

  LoginSelectUser({Key key, this.label, this.icon, @required this.items})
      : super(key: key);

  @override
  _LoginSelectUserState createState() => _LoginSelectUserState();
}

class _LoginSelectUserState extends State<LoginSelectUser> {
  String _selectValue = "";
  List<DropdownMenuItem<String>> dropdownMenuItemList = [];

  @override
  void initState() {
    super.initState();
    getDropdownMenuItemList();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return dropdownMenuItemList.isEmpty
        ? Text("暂无数据")
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: InputDecorator(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).accentColor,
                  size: 20,
                ),
                errorText: _selectValue == null ? "请选择用户" : null,
                hintText: "hint Text",
                hintStyle: TextStyle(fontSize: 15),
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
              child: DropdownButton<String>(
                  value: _selectValue,
                  isDense: true,
                  isExpanded: true,
                  underline: Container(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectValue = newValue;
                    });
                  },
                  //无内容显示
                  disabledHint: Text("暂无账号信息"),
                  //无匹配显示
                  hint: Text("请选择账号"),
                  items: dropdownMenuItemList),
            ),
          );
  }

  void getDropdownMenuItemList() {
    if (widget.items != null && widget.items.isNotEmpty) {
      List<DropdownMenuItem<String>> thisList = widget.items
          .map(
            (value) => DropdownMenuItem<String>(
              value: value.getShowValue(),
              child: Text(value.getShowLabel()),
            ),
          )
          .toList();
      dropdownMenuItemList.addAll(thisList);
      *//*setState(() {

      });*//*
    }
  }
}*/

/// 登录页面表单字段框封装类
class LoginTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputAction textInputAction;
  final int maxLength;

  LoginTextField(
      {this.label,
      this.icon,
      this.controller,
      this.obscureText: false,
      this.validator,
      this.textInputAction,
      this.maxLength});

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  TextEditingController controller;

  /// 默认遮挡密码
  ValueNotifier<bool> obscureNotifier;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    obscureNotifier = ValueNotifier(widget.obscureText);
    super.initState();
  }

  @override
  void dispose() {
    obscureNotifier.dispose();
    // 默认没有传入controller,需要内部释放
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ValueListenableBuilder(
        valueListenable: obscureNotifier,
        builder: (context, value, child) => TextFormField(
          maxLength: widget.maxLength,
          controller: controller,
          obscureText: value,
          validator: (text) {
            var validator = widget.validator ?? (_) => null;
            return text.trim().length > 0
                ? validator(text)
                : S.of(context).fieldNotNull;
          },
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: theme.accentColor,
              size: 20,
            ),
            hintText: widget.label,
            hintStyle: TextStyle(fontSize: 15),
            suffixIcon: LoginTextFieldSuffixIcon(
              controller: controller,
              obscureText: widget.obscureText,
              obscureNotifier: obscureNotifier,
            ),
          ).applyDefaults(theme.inputDecorationTheme),
        ),
      ),
    );
  }
}

class LoginTextFieldSuffixIcon extends StatelessWidget {
  final TextEditingController controller;

  final ValueNotifier<bool> obscureNotifier;

  final bool obscureText;

  LoginTextFieldSuffixIcon(
      {this.controller, this.obscureNotifier, this.obscureText});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Offstage(
          offstage: !obscureText,
          child: InkWell(
            onTap: () {
//              debugPrint('onTap');
              obscureNotifier.value = !obscureNotifier.value;
            },
            child: ValueListenableBuilder(
              valueListenable: obscureNotifier,
              builder: (context, value, child) => Icon(
                CupertinoIcons.eye,
                size: 30,
                color: value ? theme.hintColor : theme.accentColor,
              ),
            ),
          ),
        ),
        LoginTextFieldClearIcon(controller)
      ],
    );
  }
}

class LoginTextFieldClearIcon extends StatefulWidget {
  final TextEditingController controller;

  LoginTextFieldClearIcon(this.controller);

  @override
  _LoginTextFieldClearIconState createState() =>
      _LoginTextFieldClearIconState();
}

class _LoginTextFieldClearIconState extends State<LoginTextFieldClearIcon> {
  ValueNotifier<bool> notifier;

  @override
  void initState() {
    notifier = ValueNotifier(widget.controller.text.isEmpty);
    widget.controller.addListener(() {
      notifier.value = widget.controller.text.isEmpty;
    });
    super.initState();
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, bool value, child) {
        return Offstage(
          offstage: value,
          child: child,
        );
      },
      child: InkWell(
          onTap: () {
            widget.controller.clear();
          },
          child: Icon(CupertinoIcons.clear,
              size: 30, color: Theme.of(context).hintColor)),
    );
  }
}
