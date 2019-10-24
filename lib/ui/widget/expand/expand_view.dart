import 'package:flutter/material.dart';
import '../../../utils/utils.dart';

class ExpandView extends StatefulWidget {
  final TriggerComponent headComponent;
  final TriggerComponent dropDownComponent;

  //关闭菜单而不是弹出
  final bool closeMenuInsteadOfPop;

  //允许菜单在打开完成之前关闭
  final bool allowMenuToCloseBeforeOpenCompletes;

  //是否按照上级宽度设置弹出框宽度
  final bool superiorWidth;

  //最大宽度,superiorWidth:true,设置无效
  final double maxWidth;

  ExpandView(
      {Key key,
      this.headComponent,
      this.dropDownComponent,
      this.closeMenuInsteadOfPop: true,
      this.allowMenuToCloseBeforeOpenCompletes: true,
      this.superiorWidth: true,
      this.maxWidth})
      : assert(superiorWidth != null),
        super(key: key);

  @override
  _ExpandViewState createState() => _ExpandViewState();
}

class _ExpandViewState extends State<ExpandView> with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  TriggerComponent _headComponent;
  TriggerComponent _dropDownComponent;
  MenuState _menuState;
  OverlayEntry _menuOverlay;
  double _maxWidth;

  @override
  void initState() {
    super.initState();
    _headComponent = widget.headComponent ?? DropdownTriggerComponent();
    _dropDownComponent = widget.dropDownComponent;
    _menuState = MenuState.Closed;
    if (widget.maxWidth == null || widget.maxWidth < 1) {
      _maxWidth = Utils.width;
    } else {
      _maxWidth = widget.maxWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_menuOverlay != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _menuOverlay.markNeedsBuild();
      });
    }
    return CompositedTransformTarget(
      link: _layerLink,
      child: WillPopScope(
        onWillPop: () => _handleOnWillPop(),
        child: _buildHeadTrigger(),
      ),
    );
  }

  void initMenuOverlay() {
    () async {
      _menuOverlay = _buildMenuOverlayEntry();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _menuOverlay.markNeedsBuild();
      });
    }()
        .then((_) {});
  }

  Widget _buildHeadTrigger() {
    return _headComponent.build(TriggerComponentData(
        context: context,
        triggerMenu: _onTriggered,
        tickerProvider: this,
        menuState: _menuState,
        switchFlag: _getSwitchFlag()));
  }

  Widget _buildContentTrigger() {
    if (_dropDownComponent == null) {
      return Card(
        child: Container(
          height: 30,
          child: Text("展开"),
        ),
      );
    }
    return _dropDownComponent.build(TriggerComponentData(
        context: context,
        triggerMenu: _onTriggered,
        tickerProvider: this,
        menuState: _menuState,
        switchFlag: _getSwitchFlag()));
  }

  OverlayEntry _buildMenuOverlayEntry() {
    final Size viewSize = (context.findRenderObject() as RenderBox).size;
    final height = viewSize.height;
    final width = viewSize.width;
    return OverlayEntry(builder: (BuildContext context) {
      List<Widget> children = [];
      Widget content = CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0.0, height),
        child: Container(
          constraints: BoxConstraints(
              maxWidth: widget.superiorWidth ? width : _maxWidth),
          child: _buildContentTrigger(),
        ),
      );
      children.add(content);
      _handleAnimationState();
      return Stack(
        children: children,
      );
    });
  }

  void _onTriggered() {
    if (_menuOverlay == null) {
      initMenuOverlay();
    }
    if (_menuState == MenuState.Opened ||
        _menuState == MenuState.OpeningStart ||
        _menuState == MenuState.OpeningEnd) {
      _closeOverlayMenu();
      _onMenuClosedCallback();
    } else {
      _showOverlayMenu();
      _onMenuOpenedCallback();
    }
  }

  bool _getSwitchFlag() {
    if (_menuState == MenuState.Opened ||
        _menuState == MenuState.OpeningEnd ||
        _menuState == MenuState.OpeningStart) {
      return true;
    }
    return false;
  }

  Future<bool> _handleOnWillPop() async {
    if (_getSwitchFlag()) {
      _closeOverlayMenu();
      return !widget.closeMenuInsteadOfPop;
    }
    return true;
  }

  _closeOverlayMenu() {
    if (_menuState == MenuState.Opened) {
      setState(() {
        _menuState = MenuState.ClosingStart;
      });
    } else if (widget.allowMenuToCloseBeforeOpenCompletes &&
        (_menuState == MenuState.OpeningStart ||
            _menuState == MenuState.OpeningEnd)) {
      setState(() {
        _menuState = MenuState.ClosingStart;
      });
    }
  }

  _showOverlayMenu() {
    if (_menuState == MenuState.Closed) {
      //显示到屏幕上
      Overlay.of(context).insert(_menuOverlay);
      //WidgetsBinding.instance.addPostFrameCallback((_) => Overlay.of(context).insert(_menuOverlay));
      setState(() {
        _menuState = MenuState.OpeningStart;
      });
    }
  }

  void _onMenuOpenedCallback() {
    if (_menuState == MenuState.OpeningEnd) {
      setState(() {
        _menuState = MenuState.Opened;
      });
    }
  }

  void _onMenuClosedCallback() {
    if (_menuState != MenuState.Closed) {
      //移除屏幕
      _menuOverlay.remove();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _menuState = MenuState.Closed;
        });
      });
    }
  }

  void _handleAnimationState() {
    switch (_menuState) {
      case MenuState.OpeningStart:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _menuState = MenuState.OpeningEnd;
          });
        });
        break;
      case MenuState.OpeningEnd:
        break;
      case MenuState.ClosingStart:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _menuState = MenuState.ClosingEnd;
          });
        });
        break;
      case MenuState.ClosingEnd:
        break;
      case MenuState.Opened:
        break;
      case MenuState.Closed:
        break;
    }
  }

  @override
  void dispose() {
    if (_menuOverlay != null) {
      try {
        _menuOverlay.remove();
      } catch (_) {}
      _menuOverlay = null;
    }
    super.dispose();
  }
}

//菜单状态
enum MenuState {
  OpeningStart,
  OpeningEnd,
  Opened,
  ClosingStart,
  ClosingEnd,
  Closed
}

class TriggerComponent {
  TriggerBuilder builder;

  TriggerComponent({@required this.builder});

  Widget build(TriggerComponentData data) {
    return builder(data);
  }
}

class TriggerComponentData {
  final BuildContext context;

  final TriggerMenu triggerMenu;

  /// Must not be null.
  final TickerProvider tickerProvider;

  final MenuState menuState;

  final bool switchFlag;

  TriggerComponentData(
      {@required this.context,
      @required this.triggerMenu,
      @required this.tickerProvider,
      @required this.menuState,
      @required this.switchFlag})
      : assert(
            context != null && triggerMenu != null && tickerProvider != null);
}

class DropdownTriggerComponent extends TriggerComponent {
  DropdownTriggerComponent() {
    super.builder = _builder;
  }

  Widget _builder(TriggerComponentData data) {
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: data.triggerMenu,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Choose "),
          Icon(data.switchFlag ? Icons.arrow_drop_down : Icons.arrow_drop_up),
        ],
      ),
    );
  }
}

typedef Widget TriggerBuilder(TriggerComponentData data);
//Callback to Open/Close the menu.
typedef void TriggerMenu();
