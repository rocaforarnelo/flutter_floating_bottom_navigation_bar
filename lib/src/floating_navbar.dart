import 'package:floating_bottom_navigation_bar/src/floating_navbar_item.dart';
import 'package:flutter/material.dart';

class FloatingNavbar extends StatefulWidget {
  final List<FloatingNavbarItem> items;
  final int currentIndex;
  final int Function(int val) onTap;
  final Color backgroundColor, shadowColor;
  final TextStyle labelStyle;
  final Widget collapseButtonChild;
  final double iconSize, itemPadding, height, collapseButtonWidth;
  final BorderRadiusGeometry navBarBorderRadius, itemBorderRadius;
  final EdgeInsets padding;

  const FloatingNavbar({
    Key key,
    @required this.items,
    @required this.currentIndex,
    @required this.onTap,
    this.backgroundColor = Colors.black,
    this.iconSize = 24.0,
    this.padding = const EdgeInsets.all(5),
    @required this.navBarBorderRadius,
    @required this.labelStyle,
    @required this.itemBorderRadius,
    this.shadowColor = Colors.black,
    this.itemPadding = 0,
    this.height = 100,
    this.collapseButtonWidth = 40,
    @required this.collapseButtonChild,
  })  : assert(items.length > 1),
        assert(items.length <= 5),
        assert(currentIndex <= items.length),
        super(key: key);

  @override
  _FloatingNavbarState createState() => _FloatingNavbarState();
}

class _FloatingNavbarState extends State<FloatingNavbar> {
  List<FloatingNavbarItem> get items => widget.items;

  @override
  void initState() {
    super.initState();
    items.add(FloatingNavbarItem(icon: Icons.ac_unit, title: 'Collapse'));
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                  borderRadius: widget.navBarBorderRadius,
                  color: widget.backgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: widget.shadowColor,
                        blurRadius: 8,
                        offset: Offset(0, 0))
                  ]),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: items.map((f) {
                    if (items.indexOf(f) == items.length)
                      return Expanded(
                        child: SizedBox.fromSize(
                          size: Size.fromWidth(widget.collapseButtonWidth),
                          child: InkWell(
                            child: widget.collapseButtonChild,
                          ),
                        ),
                      );
                    else
                      return _buildExpanded(f, context);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildExpanded(FloatingNavbarItem f, BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedContainer(
            height: widget.height,
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
                color: widget.currentIndex == items.indexOf(f)
                    ? f.selectedColor
                    : widget.backgroundColor,
                borderRadius: widget.itemBorderRadius),
            child: InkWell(
              onTap: () {
                this.widget.onTap(items.indexOf(f));
              },
              borderRadius: widget.itemBorderRadius,
              child: Container(
                //max-width for each item
                //24 is the padding from left and right
                width: MediaQuery.of(context).size.width *
                        (100 / (items.length * 100)) -
                    widget.itemPadding,
                padding: EdgeInsets.all(4),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      f.icon,
                      color: widget.currentIndex == items.indexOf(f)
                          ? f.selectedIconColor
                          : f.unselectedIconColor,
                      size: widget.iconSize,
                    ),
                    Text(
                      '${f.title}',
                      style: widget.labelStyle.copyWith(
                          color: widget.currentIndex == items.indexOf(f)
                              ? f.selectedLabelColor
                              : f.unselectedLabelColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
