import 'package:cubekit/material_color/color_set.dart';
import 'package:cubekit/model/app.dart';
import 'package:cubekit/views/pages/sett_pag.dart';
import 'package:cubekit/views/pages/solves_pag.dart';
import 'package:cubekit/views/pages/timer_pag.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScr extends StatefulWidget {
  const MainScr({Key? key}) : super(key: key);

  @override
  _MainScrState createState() => _MainScrState();
}

class _MainScrState extends State<MainScr> {
  int _selectedIndex = 0;
  var _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [TimerPag(), SolvesPag(), SettPag()],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
      // IndexedStack(
      //   index: _selectedIndex,
      //   children: [TimerPag(), SolvesPag(), SettPag()],
      // ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: ColorSet.black_panel,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 3,
            ),
          ],
        ),
        child: GNav(
          selectedIndex: _selectedIndex,
          onTabChange: (index) => setState(() {
            if (App.state > 0) {
              print('move to $_selectedIndex');
              return;
            }
            _selectedIndex = index;
            _pageController.animateToPage(
              _selectedIndex,
              duration: Duration(milliseconds: 500),
              curve: Curves.linear,
            );
            // if (_pageController.hasClients) {
            //   _pageController.animateToPage(index,
            //       duration: Duration(milliseconds: 300), curve: Curves.ease);
            // }
          }),
          gap: 10,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 500),
          backgroundColor: ColorSet.black_panel,
          hoverColor: ColorSet.black_header, // tab button hover color
          tabBorderRadius: 100,
          color: ColorSet.black_header, // unselected icon color
          activeColor: ColorSet.black_content, // selected icon and text color
          iconSize: 24, // tab button icon size
          tabBackgroundColor:
              ColorSet.black_panel, // selected tab background color,
          padding: EdgeInsets.symmetric(
              horizontal: 10, vertical: 10), // navigation bar padding
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          tabs: [
            GButton(
              icon: Icons.timelapse,
              text: 'Timer',
              backgroundColor: ColorSet.black_header.withOpacity(0.1),
            ),
            GButton(
              icon: Icons.list_alt,
              text: 'Solves',
              backgroundColor: ColorSet.black_header.withOpacity(0.1),
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
              backgroundColor: ColorSet.black_header.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }
}
