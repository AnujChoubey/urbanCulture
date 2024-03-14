import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urban_culture/screens/routines.dart';
import 'package:urban_culture/screens/streaks.dart';
import 'package:urban_culture/styles/app_color_helper.dart';
import 'package:urban_culture/styles/text_theme_helper.dart';

import '../globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final GlobalKey<_HomePageState> _globalKey =
  GlobalKey<_HomePageState>(debugLabel: 'btm_app_bar');
  final List<Widget> _screens = [
    RoutineScreenParent(),
    StreaksScreen(),
  ];

  final List<String> title = ['Daily Skincare', 'Streaks'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    globalKey = _globalKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFCF7FA),
      appBar: AppBar(
        backgroundColor: Color(0xffFCF7FA),

        centerTitle: true,
        title: Text(
          title[_currentIndex],
          style: TextThemeHelper.black_18_700,
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: AppColorHelper.boxColor,thickness: 1,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *0.2),
            child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
              child: BottomNavigationBar(
                key: _globalKey,
                backgroundColor: Color(0xffFCF7FA),
                fixedColor: AppColorHelper.appColor,
                selectedLabelStyle: TextThemeHelper.appColor_14_400,
                unselectedLabelStyle:TextThemeHelper.appColor_14_400,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                onTap: (index) {
                  HapticFeedback.vibrate();

                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/routines_icon.png',
                      height: 24,
                      width: 24,
                    ),
                    label: 'Routine',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/streaks_icon.png',
                      height: 24,
                      width: 24,
                    ),
                    label: 'Streaks',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
