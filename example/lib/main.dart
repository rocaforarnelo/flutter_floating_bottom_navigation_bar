import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<FloatingNavbarItem> navBarItems = [
    FloatingNavbarItem(icon: Icons.search, title: 'Search'),
    FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
    FloatingNavbarItem(icon: Icons.create, title: 'Edit'),
    FloatingNavbarItem(icon: Icons.message, title: 'Messages')
  ];
  CollapseNotifier collapseNotifier = CollapseNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      extendBody: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox.fromSize(
                  size: Size.fromHeight(100),
                  child: Container(
                    color: Colors.redAccent,
                    child: FlatButton(
                        onPressed: () {
                          print('wew');
                        },
                        child: Icon(Icons.wallpaper)),
                  ))),
          Align(
              alignment: Alignment.bottomRight,
              child: SizedBox.fromSize(
                  size: Size(100, 100),
                  child: Container(
                    color: Colors.blue,
                    child: FlatButton(
                        onPressed: () {
                          collapseNotifier.toggle();
                        },
                        child: Icon(Icons.wallpaper)),
                  ))),
        ],
      ),
      bottomNavigationBar:
          _buildBottomNavigationBar(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildBottomNavigationBar() {
    return FloatingNavbar(
      collapseButtonChild: Container(
        color: Colors.white,
        child: Icon(Icons.chevron_right),
      ),
      collapseNotifier: collapseNotifier,
      collapseButtonSize: Size(30, 40),
      backgroundColor: Colors.white,
      items: navBarItems,
      height: 42,
      itemPadding: 16,
      padding: EdgeInsets.symmetric(vertical: 2),
      shadowColor: Colors.black,
      iconSize: 17,
      labelStyle: TextStyle(fontSize: 10),
      navBarBorderRadius: BorderRadius.circular(2),
      itemBorderRadius: BorderRadius.circular(0),
      currentIndex: _selectedIndex,
      onTap: (int val) {
        setState(() {
          _selectedIndex = val;
        });
        return _selectedIndex;
      },
    );
  }
}
