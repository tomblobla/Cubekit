// import 'package:bottom_navy_bar/bottom_navy_bar.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class Page1 extends StatefulWidget {
//   @override
//   _Page1State createState() => _Page1State();
// }

// class _Page1State extends State<Page1> {
//   int count = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Center(
//           child: Text(
//             '$count',
//             style: Theme.of(context).textTheme.headline2,
//           ),
//         ),
//         RaisedButton(
//           onPressed: () {
//             setState(() {
//               count++;
//             });
//           },
//           child: Text('Increment'),
//         )
//       ],
//     );
//   }
// }

// class Page2 extends StatefulWidget {
//   @override
//   _Page2State createState() => _Page2State();
// }

// class _Page2State extends State<Page2> {
//   int count = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Center(
//           child: Text(
//             '$count',
//             style: Theme.of(context).textTheme.headline2,
//           ),
//         ),
//         RaisedButton(
//           onPressed: () {
//             setState(() {
//               count--;
//             });
//           },
//           child: Text('Decrement'),
//         )
//       ],
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final List<Widget> pages = [Page1(), Page2()];
//   int _selectedIndex = 0;
//   late PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// //    body: pages[selectedIndex]
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: pages,
//       ),
//       bottomNavigationBar: BottomNavyBar(
//         selectedIndex: _selectedIndex,
//         showElevation: true, // use this to remove appBar's elevation
//         onItemSelected: (index) => setState(() {
//           _selectedIndex = index;
//           _pageController.animateToPage(index,
//               duration: Duration(milliseconds: 300), curve: Curves.ease);
//         }),
//         items: [
//           BottomNavyBarItem(
//             icon: Icon(Icons.apps),
//             title: Text('Home'),
//             activeColor: Colors.red,
//           ),
//           BottomNavyBarItem(
//               icon: Icon(Icons.people),
//               title: Text('Users'),
//               activeColor: Colors.purpleAccent),
//           BottomNavyBarItem(
//               icon: Icon(Icons.message),
//               title: Text('Messages'),
//               activeColor: Colors.pink),
//           BottomNavyBarItem(
//               icon: Icon(Icons.settings),
//               title: Text('Settings'),
//               activeColor: Colors.blue),
//         ],
//       ),
//     );
//   }
// }

import 'package:cubekit/model/app.dart';
import 'package:cubekit/views/main_screen.dart';
import 'package:cubekit/views/splash_screen.dart';
import 'package:flutter/material.dart';

import 'material_color/color_set.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        scaffoldBackgroundColor: ColorSet.black_bg,
        fontFamily: 'RusselSquareOpti',
      ),
      title: "Cubekit",
      initialRoute: '/splash_scr',
      routes: {
        '/splash_scr': (context) => const SplashScr(),
        '/main_scr': (context) => const MainScr(),
      },
    );
  }
}
