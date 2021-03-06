import 'package:floating_bottom_navigation_bar/src/floating_navbar_item.dart';
import 'package:flutter/material.dart';

class FloatingNavbar extends StatefulWidget {
  final List<FloatingNavbarItem> items;
  final int currentIndex;
  final int Function(int val) onTap;
  final Color backgroundColor, shadowColor;
  final TextStyle labelStyle;
  final FloatingNavbarItem collapseButtonChild;
  final int collapseButtonFlex;
  final int buttonFlex;
  final CollapseNotifier collapseNotifier;
  final double iconSize, itemPadding, height, collapseButtonIconSize;
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
    @required this.collapseButtonChild,
    @required this.collapseNotifier,
    this.collapseButtonFlex = 1,
    this.buttonFlex = 2,
    this.collapseButtonIconSize = 24,
  })  : assert(items.length > 1),
        assert(items.length <= 5),
        assert(currentIndex <= items.length),
        super(key: key);

  @override
  _FloatingNavbarState createState() => _FloatingNavbarState();
}

class _FloatingNavbarState extends State<FloatingNavbar>
    with SingleTickerProviderStateMixin {
  List<FloatingNavbarItem> _items;
  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  bool _collapse = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0);
    _scaleAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastLinearToSlowEaseIn);
    _animationController.forward();
    widget.collapseNotifier.addListener(() {
      if (!widget.collapseNotifier.value)
        setState(() {
          _collapse = false;
          _animationController.forward();
        });
    });
    _items = widget.items;
    _items.add(FloatingNavbarItem(icon: Icons.ac_unit, title: 'Collapse'));
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _collapse
        ? SizedBox.fromSize(size: Size(0, 0))
        : BottomAppBar(
            color: Colors.transparent, elevation: 0, child: _buildItems());
  }

  Column _buildItems() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Align(
            alignment: Alignment.centerRight,
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
              child: SizeTransition(
                axis: Axis.horizontal,
                axisAlignment: -50,
                sizeFactor: _scaleAnimation,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: _buildChildren(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> children = _items.map((f) {
      if (_items.indexOf(f) == _items.length - 1)
        return _buildCollapseButton(widget.collapseButtonChild);
      else
        return _buildExpanded(f, context);
    }).toList();
    return children;
  }

  Widget _buildCollapseButton(FloatingNavbarItem f) {
    return Expanded(
      flex: widget.collapseButtonFlex,
      child: AnimatedContainer(
        height: widget.height,
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
            color: widget.currentIndex == _items.indexOf(f)
                ? f.selectedColor
                : widget.backgroundColor,
            borderRadius: widget.itemBorderRadius),
        child: InkWell(
          onTap: () {
            _animationController.reverse().whenComplete(() {
              widget.collapseNotifier.toggle();
              setState(() {
                _collapse = true;
              });
            });
          },
          borderRadius: widget.itemBorderRadius,
          child: Container(
            padding: EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                f.icon != null
                    ? Icon(
                        f.icon,
                        color: widget.currentIndex == _items.indexOf(f)
                            ? f.selectedIconColor
                            : f.unselectedIconColor,
                        size: widget.iconSize,
                      )
                    : SizedBox.fromSize(
                        size: Size(widget.collapseButtonIconSize,
                            widget.collapseButtonIconSize),
                        child: Image.asset(f.iconPath, fit: BoxFit.contain)),
                Text(
                  '${f.title}',
                  style: widget.labelStyle.copyWith(
                      color: widget.currentIndex == _items.indexOf(f)
                          ? f.selectedLabelColor
                          : f.unselectedLabelColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpanded(FloatingNavbarItem f, BuildContext context) {
    return Expanded(
      flex: widget.buttonFlex,
      child: AnimatedContainer(
        height: widget.height,
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
            color: widget.currentIndex == _items.indexOf(f)
                ? f.selectedColor
                : widget.backgroundColor,
            borderRadius: widget.itemBorderRadius),
        child: InkWell(
          onTap: () {
            this.widget.onTap(_items.indexOf(f));
          },
          borderRadius: widget.itemBorderRadius,
          child: Container(
            padding: EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  f.icon,
                  color: widget.currentIndex == _items.indexOf(f)
                      ? f.selectedIconColor
                      : f.unselectedIconColor,
                  size: widget.iconSize,
                ),
                Text(
                  '${f.title}',
                  style: widget.labelStyle.copyWith(
                      color: widget.currentIndex == _items.indexOf(f)
                          ? f.selectedLabelColor
                          : f.unselectedLabelColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingUncollapseButton extends StatefulWidget {
  final Widget child;
  final Color backgrounColor;
  final CollapseNotifier collapseNotifier;

  const FloatingUncollapseButton(
      {Key key, this.child, this.collapseNotifier, this.backgrounColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FloatingUncollapseButtonState();
}

class _FloatingUncollapseButtonState extends State<FloatingUncollapseButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: widget.child,
        backgroundColor: widget.backgrounColor,
        onPressed: () {
          widget.collapseNotifier.toggle();
        });
    // Stack(
    //   children: <Widget>[
    //     AnimatedPositioned(
    //         left: 0,
    //         right: 0,
    //         bottom: !widget.collapseNotifier.value ? -100 : 0,
    //         duration: Duration(seconds: 1),
    //         child: FloatingActionButton(
    //             child: widget.child,
    //             backgroundColor: widget.backgrounColor,
    //             onPressed: () {
    //               widget.collapseNotifier.toggle();
    //             }))
    //   ],
    // );
  }
}
