import 'dart:math';

import 'package:flutter/material.dart';

typedef WidgetBuilder = Widget Function(
    BuildContext context, Map<String, dynamic> item);
typedef OnSelected = void Function(dynamic item);

class DropdownInput extends StatefulWidget {
  final double maxHeight;
  final double itemHeight;
  final OnSelected onItemSelected;
  final MaterialColor themeColor;
  final Color titleColor;
  final double titleSize;
  final Color inputColor;
  final double inputSize;
  final double inputWidth;
  final String hintText;
  final String noResultText;
  final bool showClearIcon;
  final double clearIconSize;
  final double dropdownIconSize;
  final List<Map<String, dynamic>> optionsList;
  final EdgeInsetsGeometry? childrenPadding;
  final EdgeInsetsGeometry? childrenMargin;
  final BoxDecoration? childrenBoxDecoration;
  final ValueChanged<String>? onChanged;

  /*
  * 只能根据filterField的值来过滤
  * 选择结果后filterField的值会被填充到输入框中
  * */
  final String filterField;

  final TextAlign? textAlign;
  final Widget? title;
  final WidgetBuilder itemWidget;

  const DropdownInput(
      {super.key,
      this.maxHeight = 100.0,
      this.itemHeight = 50.0,
      required this.onItemSelected,
      this.themeColor = Colors.blue,
      this.titleColor = Colors.black,
      this.titleSize = 16.0,
      this.inputColor = Colors.black,
      this.inputSize = 16.0,
      this.inputWidth = 150,
      this.hintText = "Search",
      this.noResultText = "No result",
      this.showClearIcon = true,
      this.clearIconSize = 32.0,
      this.dropdownIconSize = 32.0,
      this.textAlign,
      this.title,
      this.childrenPadding,
      this.childrenMargin,
      this.childrenBoxDecoration,
      this.onChanged,
      required this.optionsList,
      required this.filterField,
      required this.itemWidget});

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionWidget(
        maxHeight: widget.maxHeight,
        itemHeight: widget.itemHeight,
        onItemSelected: widget.onItemSelected,
        themeColor: widget.themeColor,
        titleColor: widget.titleColor,
        inputColor: widget.inputColor,
        inputSize: widget.inputSize,
        inputWidth: widget.inputWidth,
        hintText: widget.hintText,
        noResultText: widget.noResultText,
        showClearIcon: widget.showClearIcon,
        clearIconSize: widget.clearIconSize,
        dropdownIconSize: widget.dropdownIconSize,
        optionsList: widget.optionsList,
        filterField: widget.filterField,
        textAlign: widget.textAlign,
        title: widget.title,
        itemWidget: widget.itemWidget,
        onChanged: widget.onChanged,
        childrenPadding: widget.childrenPadding,
        childrenMargin: widget.childrenMargin,
        childrenBoxDecoration: widget.childrenBoxDecoration);
  }
}

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionWidget extends StatefulWidget {
  final Widget? leading;

  // final Widget title;
  final Widget? subtitle;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final Widget? title;
  final bool initiallyExpanded;
  final bool maintainState;
  final EdgeInsetsGeometry? tilePadding;
  final Alignment? expandedAlignment;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final EdgeInsetsGeometry? childrenMargin;
  final BoxDecoration? childrenBoxDecoration;
  final Color? iconColor;
  final Color? collapsedIconColor;
  final Color? textColor;
  final Color? collapsedTextColor;
  final ShapeBorder? shape;
  final ShapeBorder? collapsedShape;
  final Clip? clipBehavior;
  final ListTileControlAffinity? controlAffinity;
  final double maxHeight;
  final double itemHeight;
  final OnSelected onItemSelected;
  final MaterialColor themeColor;
  final Color titleColor;
  final double titleSize;
  final Color inputColor;
  final double inputSize;
  final double inputWidth;

  final String hintText;
  final String noResultText;
  final bool showClearIcon;
  final double clearIconSize;
  final double dropdownIconSize;
  final List<Map<String, dynamic>> optionsList;
  final String filterField;
  final TextAlign? textAlign;
  final WidgetBuilder itemWidget;
  final ValueChanged<String>? onChanged;

  // final bool isExpanded;

  const ExpansionWidget(
      {super.key,
      this.leading,
      // required this.title,
      this.subtitle,
      this.onExpansionChanged,
      this.children = const <Widget>[],
      this.title,
      this.initiallyExpanded = false,
      this.maintainState = false,
      this.tilePadding,
      this.expandedCrossAxisAlignment,
      this.expandedAlignment,
      this.childrenPadding,
      this.childrenMargin,
      this.childrenBoxDecoration,
      this.backgroundColor,
      this.collapsedBackgroundColor,
      this.textColor,
      this.collapsedTextColor,
      this.iconColor,
      this.collapsedIconColor,
      this.shape,
      this.collapsedShape,
      this.clipBehavior,
      this.controlAffinity,
      // required this.isExpanded,
      this.maxHeight = 100.0,
      this.itemHeight = 50.0,
      required this.onItemSelected,
      this.themeColor = Colors.blue,
      this.titleColor = Colors.black,
      this.titleSize = 16.0,
      this.inputColor = Colors.black,
      this.inputSize = 16.0,
      this.inputWidth = 150,
      this.hintText = "Search",
      this.noResultText = "No result",
      this.showClearIcon = true,
      this.clearIconSize = 32.0,
      this.dropdownIconSize = 32.0,
      this.textAlign,
      this.onChanged,
      required this.optionsList,
      required this.filterField,
      required this.itemWidget})
      : assert(
          expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
          'CrossAxisAlignment.baseline is not supported since the expanded children '
          'are aligned in a column, not a row. Try to use another constant.',
        );

  @override
  State<ExpansionWidget> createState() => _ExpansionWidgetState();
}

class _ExpansionWidgetState extends State<ExpansionWidget>
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
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<ShapeBorder?> _border;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  TextEditingController textEditingController = TextEditingController();

  List<Map<String, dynamic>> optionsList = [];

  List<Map<String, dynamic>> optionsListFiltered = [];

  // List<Widget> optionListWidget() {
  //   if (textEditingController.text != "") {
  //     return optionsListFiltered
  //         .map((e) => ListTile(
  //               title: Text(e["name"]),
  //             ))
  //         .toList();
  //   } else {
  //     return [
  //       const ListTile(
  //         title: Text("No result"),
  //       )
  //     ];
  //   }
  // }

  void setOptionListWidget() {
    if (textEditingController.text != "") {
      List<Map<String, dynamic>> temp = [];
      for (var element in optionsList) {
        if (element[widget.filterField] != null) {
          if (element[widget.filterField]
              .toString()
              .contains(textEditingController.text)) {
            temp.add(element);
          }
        }
      }
      setState(() {
        optionsListFiltered = temp;
        if (temp.isNotEmpty) {
          _isExpanded = true;
          _controller.forward();
        }
      });
    } else {
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
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _border = _controller.drive(_borderTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    optionsList = widget.optionsList;
    optionsListFiltered = widget.optionsList;

    if (_isExpanded) {
      _controller.value = 1.0;
    }

    textEditingController.addListener(setOptionListWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
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
      // PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  // Platform or null affinity defaults to trailing.
  ListTileControlAffinity _effectiveAffinity(
      ListTileControlAffinity? affinity) {
    switch (affinity ?? ListTileControlAffinity.trailing) {
      case ListTileControlAffinity.leading:
        return ListTileControlAffinity.leading;
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
        return ListTileControlAffinity.trailing;
    }
  }

  Widget? _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: IconButton(
        onPressed: () {
          setState(() {
            optionsListFiltered = optionsList;
          });
          _handleTap();
        },
        icon: Icon(
          Icons.expand_more,
          color: widget.themeColor,
          size: widget.dropdownIconSize,
        ),
      ),
    );
  }

  Widget? _buildLeadingIcon(BuildContext context) {
    if (_effectiveAffinity(widget.controlAffinity) !=
        ListTileControlAffinity.leading) {
      return null;
    }
    return _buildIcon(context);
  }

  // Widget? _buildTrailingIcon(BuildContext context) {
  //   if (_effectiveAffinity(widget.controlAffinity) !=
  //       ListTileControlAffinity.trailing) {
  //     return null;
  //   }
  //   return _buildIcon(context);
  // }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final ShapeBorder expansionTileBorder = _border.value ??
        const Border(
          top: BorderSide(color: Colors.transparent),
          bottom: BorderSide(color: Colors.transparent),
        );
    final Clip clipBehavior = widget.clipBehavior ?? Clip.none;

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
            iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
            textColor: _headerColor.value,
            child: ListTile(
              contentPadding:
                  widget.tilePadding ?? expansionTileTheme.tilePadding,
              leading: widget.leading ?? _buildLeadingIcon(context),
              // title: widget.title,
              title: widget.title,
              trailing: SizedBox(
                width: widget.inputWidth,
                child: TextFormField(
                  textAlign: widget.textAlign ?? TextAlign.start,
                  controller: textEditingController,
                  cursorColor: widget.themeColor,
                  onChanged: widget.onChanged,
                  style: TextStyle(
                      color: widget.inputColor, fontSize: widget.inputSize),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(fontSize: widget.inputSize),
                      suffixIcon: widget.showClearIcon
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                size: widget.clearIconSize,
                              ),
                              onPressed: () {
                                textEditingController.text = "";
                              })
                          : null),
                ),
              ),
              subtitle: widget.subtitle,
              // trailing: widget.trailing == Container()
              //     ? _buildTrailingIcon(context)
              //     : null,
            ),
          ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment ??
                  expansionTileTheme.expandedAlignment ??
                  Alignment.center,
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
      ..begin = widget.collapsedShape ??
          const Border(
            top: BorderSide(color: Colors.transparent),
            bottom: BorderSide(color: Colors.transparent),
          )
      ..end = widget.shape ??
          Border(
            top: BorderSide(color: theme.dividerColor),
            bottom: BorderSide(color: theme.dividerColor),
          );
    _headerColorTween
      ..begin = widget.collapsedTextColor ??
          expansionTileTheme.collapsedTextColor ??
          theme.textTheme.titleMedium!.color
      ..end = widget.textColor ??
          expansionTileTheme.textColor ??
          colorScheme.primary;
    _iconColorTween
      ..begin = widget.collapsedIconColor ??
          expansionTileTheme.collapsedIconColor ??
          theme.unselectedWidgetColor
      ..end = widget.iconColor ??
          expansionTileTheme.iconColor ??
          colorScheme.primary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor ??
          expansionTileTheme.collapsedBackgroundColor
      ..end = widget.backgroundColor ?? expansionTileTheme.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

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
            height: min(widget.itemHeight * optionsListFiltered.length,
                widget.maxHeight),
            child: optionsListFiltered.isNotEmpty
                ? RawScrollbar(
                    thumbColor: widget.themeColor,
                    radius: const Radius.circular(5.0),
                    thickness: 4.0,
                    child: ListView.builder(
                      itemCount: optionsListFiltered.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> item = optionsListFiltered[index];

                        returnedWidgetBuilder(item) {
                          return GestureDetector(
                            child: widget.itemWidget(context, item),
                            onTap: () {
                              textEditingController.text =
                                  item[widget.filterField];
                              _handleTap();
                              widget.onItemSelected.call(item);
                            },
                          );
                        }

                        return returnedWidgetBuilder(item);
                      },
                      // children: widget.children,
                      //children: optionsListFiltered.map((e) => ListTile(title: Text(e["name"]),)).toList(),
                    ),
                  )
                : widget.noResultText == ""
                    ? ListTile(
                        title: Text(
                        widget.noResultText,
                        style: TextStyle(
                            color: widget.titleColor,
                            fontSize: widget.titleSize),
                      ))
                    : null,
          ),
          /*child: Column(
            crossAxisAlignment: widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: widget.children,
          ),*/
        ),
      ),
    );

    return Theme(
      data: ThemeData(primarySwatch: widget.themeColor),
      child: AnimatedBuilder(
        animation: _controller.view,
        builder: _buildChildren,
        child: shouldRemoveChildren ? null : result,
      ),
    );
  }
}
