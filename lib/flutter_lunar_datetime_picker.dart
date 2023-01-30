library flutter_lunar_datetime_picker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lunar_datetime_picker/date_init.dart';
import 'package:flutter_lunar_datetime_picker/date_model.dart';
import 'package:flutter_lunar_datetime_picker/datetime_picker_theme.dart';

typedef DateChangedCallback = Function(DateTime time, bool lunar);
typedef DateCancelledCallback = Function();
typedef StringAtIndexCallBack = String? Function(int index);

class DatePicker {
  ///
  /// Display date picker bottom sheet.
  ///
  static Future<DateTime?> showDatePicker(
    BuildContext context, {
    bool showTitleActions = true,
    DateTime? minTime,
    DateTime? maxTime,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    DateTime? currentTime,
    DatePickerTheme? theme,
    bool? lunarPicker,
    DateInitTime? dateInitTime,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        theme: theme,
        lunarPicker: lunarPicker,
        dateInitTime: dateInitTime,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ),
    );
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    this.lunarPicker,
    DatePickerTheme? theme,
    this.dateInitTime,
    this.barrierLabel,
    RouteSettings? settings,
  })  : theme = theme ?? const DatePickerTheme(),
        super(settings: settings);

  final bool? showTitleActions;
  final DateChangedCallback? onChanged;
  final DateChangedCallback? onConfirm;
  final DateCancelledCallback? onCancel;
  final DatePickerTheme theme;
  final bool? lunarPicker;
  final DateInitTime? dateInitTime;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(
        onChanged: onChanged,
        route: this,
        lunarPicker: lunarPicker ?? false,
        dateInitTime: dateInitTime,
      ),
    );
    return InheritedTheme.captureAll(context, bottomSheet);
  }
}

class _DatePickerComponent extends StatefulWidget {
  const _DatePickerComponent({
    Key? key,
    required this.route,
    this.onChanged,
    required this.lunarPicker,
    required this.dateInitTime,
  }) : super(key: key);

  final DateChangedCallback? onChanged;

  final _DatePickerRoute route;

  final bool lunarPicker;

  final DateInitTime? dateInitTime;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<_DatePickerComponent> {
  late FixedExtentScrollController leftScrollCtrl,
      middleScrollCtrl,
      rightScrollCtrl,
      hourScrollCtrl,
      minuteScrollCtrl;

  bool lunarPicker = false;

  late BasePickerModel pickerModel;

  @override
  void initState() {
    super.initState();
    // 是否阴历
    lunarPicker = widget.lunarPicker;
    if (lunarPicker) {
      pickerModel = LunarPickerModel(
          currentTime: widget.dateInitTime?.currentTime,
          maxTime: widget.dateInitTime?.maxTime,
          minTime: widget.dateInitTime?.minTime);
    } else {
      pickerModel = DatePickerModel(
          currentTime: widget.dateInitTime?.currentTime,
          maxTime: widget.dateInitTime?.maxTime,
          minTime: widget.dateInitTime?.minTime);
    }
    refreshScrollOffset();
  }

  void onLunarChange(bool lunarPicker) {
    setState(() {
      this.lunarPicker = lunarPicker;
      // debugPrint("切换类型:${pickerModel.finalTime().toString()}");
      pickerModel = lunarPicker
          ? LunarPickerModel(
              currentTime: pickerModel.finalTime(),
              maxTime: widget.dateInitTime?.maxTime,
              minTime: widget.dateInitTime?.minTime)
          : DatePickerModel(
              currentTime: pickerModel.finalTime(),
              maxTime: widget.dateInitTime?.maxTime,
              minTime: widget.dateInitTime?.minTime);
    });
    refreshScrollOffset();
    _notifyDateChanged();
  }

  void refreshScrollOffset() {
   // debugPrint('refreshScrollOffset ${pickerModel.currentMiddleIndex()}');
    leftScrollCtrl = FixedExtentScrollController(
        initialItem: pickerModel.currentLeftIndex());
    middleScrollCtrl = FixedExtentScrollController(
        initialItem: pickerModel.currentMiddleIndex());
    rightScrollCtrl = FixedExtentScrollController(
        initialItem: pickerModel.currentRightIndex());
    hourScrollCtrl = FixedExtentScrollController(
        initialItem: pickerModel.currentHourIndex());
    minuteScrollCtrl = FixedExtentScrollController(
        initialItem: pickerModel.currentMinuteIndex());
  }

  @override
  void dispose() {
    leftScrollCtrl.dispose();
    middleScrollCtrl.dispose();
    rightScrollCtrl.dispose();
    hourScrollCtrl.dispose();
    minuteScrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DatePickerTheme theme = widget.route.theme;
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation!,
        builder: (BuildContext context, Widget? child) {
          final double bottomPadding = MediaQuery.of(context).padding.bottom;
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(
                widget.route.animation!.value,
                theme,
                showTitleActions: widget.route.showTitleActions!,
                bottomPadding: bottomPadding,
              ),
              child: GestureDetector(
                child: Material(
                  color: theme.backgroundColor,
                  child: _renderPickerView(theme),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(pickerModel.finalTime()!, lunarPicker);
    }
  }

  Widget _renderPickerView(DatePickerTheme theme) {
    Widget itemView = _renderItemView(theme);
    if (widget.route.showTitleActions == true) {
      return Column(
        children: <Widget>[
          _renderTitleActionsView(theme),
          itemView,
        ],
      );
    }
    return itemView;
  }

  Widget _renderColumnView(
    ValueKey key,
    DatePickerTheme theme,
    StringAtIndexCallBack stringAtIndexCB,
    ScrollController scrollController,
    int layoutProportion,
    ValueChanged<int> selectedChangedWhenScrolling,
    ValueChanged<int> selectedChangedWhenScrollEnd,
  ) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
        // padding: const EdgeInsets.all(2.0),
        height: theme.containerHeight,
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 &&
                notification is ScrollEndNotification &&
                notification.metrics is FixedExtentMetrics) {
              final FixedExtentMetrics metrics =
                  notification.metrics as FixedExtentMetrics;
              final int currentItemIndex = metrics.itemIndex;
              selectedChangedWhenScrollEnd(currentItemIndex);
            }
            return false;
          },
          child: CupertinoPicker.builder(
            key: key,
            backgroundColor: theme.backgroundColor,
            scrollController: scrollController as FixedExtentScrollController,
            itemExtent: theme.itemHeight,
            onSelectedItemChanged: (int index) {
              selectedChangedWhenScrolling(index);
            },
            useMagnifier: true,
            itemBuilder: (BuildContext context, int index) {
              final content = stringAtIndexCB(index);
              if (content == null) {
                return null;
              }
              return Container(
                height: theme.itemHeight,
                alignment: Alignment.center,
                child: Text(
                  content,
                  style: theme.itemStyle,
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _renderItemView(DatePickerTheme theme) {
    return Container(
      color: theme.backgroundColor,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // 年
            Container(
              child: pickerModel.layoutProportions()[0] > 0
                  ? _renderColumnView(
                      ValueKey(pickerModel.currentLeftIndex()),
                      theme,
                      pickerModel.leftStringAtIndex,
                      leftScrollCtrl,
                      pickerModel.layoutProportions()[0], (index) {
                      pickerModel.setLeftIndex(index);
                    }, (index) {
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
            Text(
              pickerModel.leftDivider(),
              style: theme.itemStyle,
            ),
            // 月
            Container(
              child: pickerModel.layoutProportions()[1] > 0
                  ? _renderColumnView(
                      ValueKey(pickerModel.currentLeftIndex() * 100 +
                          pickerModel.currentMiddleIndex()),
                      theme,
                      pickerModel.middleStringAtIndex,
                      middleScrollCtrl,
                      pickerModel.layoutProportions()[1], (index) {
                      pickerModel.setMiddleIndex(index);
                    }, (index) {
                      debugPrint('index: $index');
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
            Text(
              pickerModel.rightDivider(),
              style: theme.itemStyle,
            ),
            // 日
            Container(
              child: pickerModel.layoutProportions()[2] > 0
                  ? _renderColumnView(
                      ValueKey(pickerModel.currentMiddleIndex() * 100 +
                          pickerModel.currentLeftIndex()),
                      theme,
                      pickerModel.rightStringAtIndex,
                      rightScrollCtrl,
                      pickerModel.layoutProportions()[2], (index) {
                      pickerModel.setRightIndex(index);
                    }, (index) {
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
            Text(
              pickerModel.rightDivider(),
              style: theme.itemStyle,
            ),
            Container(
              child: pickerModel.layoutProportions()[3] > 0
                  ? _renderColumnView(
                      ValueKey(pickerModel.currentMinuteIndex() * 200 +
                          pickerModel.currentHourIndex()),
                      theme,
                      pickerModel.hourStringAtIndex,
                      hourScrollCtrl,
                      pickerModel.layoutProportions()[3], (index) {
                      pickerModel.setHourIndex(index);
                    }, (index) {
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
            Text(
              pickerModel.timeDivider(),
              style: theme.itemStyle,
            ),
            Container(
              child: pickerModel.layoutProportions()[4] > 0
                  ? _renderColumnView(
                      ValueKey(pickerModel.currentMinuteIndex() * 100 +
                          pickerModel.currentHourIndex()),
                      theme,
                      pickerModel.minuteStringAtIndex,
                      minuteScrollCtrl,
                      pickerModel.layoutProportions()[4], (index) {
                      pickerModel.setMinuteIndex(index);
                    }, (index) {
                      setState(() {
                        refreshScrollOffset();
                        _notifyDateChanged();
                      });
                    })
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Title View
  Widget _renderTitleActionsView(DatePickerTheme theme) {
    const done = "完成";
    const cancel = "取消";

    return Container(
      height: theme.titleHeight,
      decoration: BoxDecoration(
        color: theme.headerColor ?? theme.backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: theme.titleHeight,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: const EdgeInsetsDirectional.only(start: 16, top: 0),
              child: Text(
                cancel,
                style: theme.cancelStyle,
              ),
              onPressed: () {
                Navigator.pop(context);
                if (widget.route.onCancel != null) {
                  widget.route.onCancel!();
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: theme.doneStyle.color!),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    onLunarChange(false);
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize:
                          MaterialStateProperty.all(const Size(50, 26)),
                      backgroundColor: lunarPicker
                          ? MaterialStateProperty.all(Colors.transparent)
                          : MaterialStateProperty.all(theme.doneStyle.color)),
                  child: Text(
                    "公历",
                    style: TextStyle(
                        color:
                            lunarPicker ? theme.doneStyle.color : Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onLunarChange(true);
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize:
                          MaterialStateProperty.all(const Size(50, 26)),
                      backgroundColor: lunarPicker
                          ? MaterialStateProperty.all(theme.doneStyle.color)
                          : MaterialStateProperty.all(Colors.transparent)),
                  child: Text("阴历",
                      style: TextStyle(
                          color: lunarPicker
                              ? Colors.white
                              : theme.doneStyle.color)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: theme.titleHeight,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: const EdgeInsetsDirectional.only(end: 16, top: 0),
              child: Text(
                done,
                style: theme.doneStyle,
              ),
              onPressed: () {
                Navigator.pop(context, pickerModel.finalTime());
                if (widget.route.onConfirm != null) {
                  widget.route.onConfirm!(
                      pickerModel.finalTime()!, lunarPicker);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(
    this.progress,
    this.theme, {
    this.showTitleActions,
    this.bottomPadding = 0,
  });

  final double progress;

  // final int? itemCount;
  final bool? showTitleActions;
  final DatePickerTheme theme;
  final double bottomPadding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = theme.containerHeight;
    if (showTitleActions == true) {
      maxHeight += theme.titleHeight;
    }

    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight + bottomPadding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
