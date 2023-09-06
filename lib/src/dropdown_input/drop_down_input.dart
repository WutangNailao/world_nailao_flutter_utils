import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

typedef WidgetBuilder = Widget Function(
    BuildContext context, Map<String, dynamic> item);
typedef OnSelected = void Function(dynamic item);

const Duration _kExpand = Duration(milliseconds: 200);

class DropdownInput extends StatefulWidget {
  final List<Map<String, dynamic>> optionsList;
  final WidgetBuilder itemWidget;
  final OnSelected onItemSelected;
  final double maxHeight;
  final double itemHeight;
  final String hintText;
  final TextAlign? textAlign;
  final double inputWidth;
  final Widget? title;
  final EdgeInsetsGeometry? childrenPadding;
  final EdgeInsetsGeometry? childrenMargin;
  final BoxDecoration? childrenBoxDecoration;
  final InputDecoration? inputDecoration;
  final TextEditingController textController;
  final ValueChanged<String>? onChanged;

  const DropdownInput(
      {super.key,
        this.title,
        this.childrenPadding,
        this.childrenMargin,
        this.childrenBoxDecoration,
        this.maxHeight = 100.0,
        this.itemHeight = 50.0,
        required this.onItemSelected,
        this.inputWidth = 150,
        this.hintText = "Search",
        this.textAlign,
        this.onChanged,
        this.inputDecoration,
        required this.textController,
        required this.optionsList,
        required this.itemWidget});

  @override
  State<DropdownInput> createState() => DropdownInputState();
}

class DropdownInputState extends State<DropdownInput>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
  CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
  CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
  Tween<double>(begin: 0.0, end: 0.5);

  final ShapeBorderTween _borderTween = ShapeBorderTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;

  // late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<ShapeBorder?> _border;

  // late Animation<Color?> _headerColor;
  // late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  late TextEditingController _textEditingController;

  List<Map<String, dynamic>> get _optionsList => widget.optionsList;

  void _setOptionListWidget() {
    if (_textEditingController.text != "") {
      setState(() {
        if (_optionsList.isNotEmpty) {
          handleExpanded(true);
        }
      });
    } else {
      handleExpanded(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    // _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _border = _controller.drive(_borderTween.chain(_easeOutTween));
    // _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    // _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    if (_isExpanded) {
      _controller.value = 1.0;
    }

    _textEditingController = widget.textController;
    // textEditingController.addListener(setOptionListWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DropdownInput oldWidget) {
    if (widget.optionsList.isEmpty) {
      handleExpanded(false);
    } else {
      handleExpanded(true);
    }
    super.didUpdateWidget(oldWidget);
  }


  void handleExpanded(bool isExpanded) {
    debugPrint('isExpanded: $isExpanded');
    if(_textEditingController.text == ""){
      setState(() {
        _isExpanded = false;
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      });
      return;
    }
    setState(() {
      _isExpanded = isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
    });
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme =
    ExpansionTileTheme.of(context);
    final ShapeBorder expansionTileBorder = _border.value ??
        const Border(
          top: BorderSide(color: Colors.transparent),
          bottom: BorderSide(color: Colors.transparent),
        );
    const Clip clipBehavior = Clip.none;

    return Container(
      clipBehavior: clipBehavior,
      decoration: ShapeDecoration(
        color: _backgroundColor.value ??
            expansionTileTheme.backgroundColor ??
            Colors.transparent,
        shape: expansionTileBorder,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            // iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
            // textColor: _headerColor.value,
            child: ListTile(
              contentPadding: expansionTileTheme.tilePadding,
              title: widget.title,
              trailing: SizedBox(
                width: widget.inputWidth,
                child: TextFormField(
                  textAlign: widget.textAlign ?? TextAlign.start,
                  controller: _textEditingController,
                  onChanged: (text) {
                    if (text.isEmpty) {
                      debugPrint('onChange empty: $text');
                      handleExpanded(false);
                      EasyDebounce.cancel('search');
                      return;
                    }
                    EasyDebounce.debounce(
                        "search", const Duration(milliseconds: 500), () {
                      debugPrint('onChange: $text');
                      if (text.isNotEmpty) {
                        widget.onChanged?.call(text);
                      }
                    });
                  },
                  decoration: widget.inputDecoration ??
                      InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hintText,
                      ),
                ),
              ),
            ),
          ),
          ClipRect(
            child: Align(
              alignment:
              expansionTileTheme.expandedAlignment ?? Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
    ExpansionTileTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderTween
      ..begin = const Border(
        top: BorderSide(color: Colors.transparent),
        bottom: BorderSide(color: Colors.transparent),
      )
      ..end = Border(
        top: BorderSide(color: theme.dividerColor),
        bottom: BorderSide(color: theme.dividerColor),
      );
    // _headerColorTween
    //   ..begin = expansionTileTheme.collapsedTextColor ?? theme.textTheme.titleMedium!.color
    //   ..end = expansionTileTheme.textColor ?? colorScheme.primary;
    _iconColorTween
      ..begin =
          expansionTileTheme.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = expansionTileTheme.iconColor ?? colorScheme.primary;
    _backgroundColorTween
      ..begin = expansionTileTheme.collapsedBackgroundColor
      ..end = expansionTileTheme.backgroundColor;
    super.didChangeDependencies();
  }

  // @override
  // void didUpdateWidget(covariant DropdownInput oldWidget) {
  //   if (oldWidget.optionsList != widget.optionsList) {
  //     _optionsList = widget.optionsList;
  //     print("_optionsList$_optionsList");
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme =
    ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Container(
          decoration: widget.childrenBoxDecoration,
          margin: widget.childrenMargin ?? EdgeInsets.zero,
          padding: widget.childrenPadding ??
              expansionTileTheme.childrenPadding ??
              EdgeInsets.zero,
          child: SizedBox(
            height:
            min(widget.itemHeight * _optionsList.length, widget.maxHeight),
            child: _optionsList.isNotEmpty
                ? RawScrollbar(
              radius: const Radius.circular(5.0),
              thickness: 4.0,
              child: ListView.builder(
                itemCount: _optionsList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = _optionsList[index];

                  returnedWidgetBuilder(Map<String, dynamic> item) {
                    return GestureDetector(
                      child: widget.itemWidget(context, item),
                      onTap: () {
                        widget.onItemSelected.call(item);
                        handleExpanded(false);
                        _optionsList.clear();
                      },
                    );
                  }

                  return returnedWidgetBuilder(item);
                },
              ),
            )
                : const Text('无数据'),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}

