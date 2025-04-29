import 'package:flight_delay_app/src/constants/variables.dart';
import 'package:flight_delay_app/src/screens/fav_flights.dart';
import 'package:flight_delay_app/src/screens/home_app.dart';
import 'package:flight_delay_app/src/screens/airports.dart';
import 'package:flight_delay_app/src/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({Key? key}) : super(key: key);

  static const String routeName = '/bottom_nav_bar';

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _selectedIndex = 1;

  final List<Widget> _pages = const [
    Airports(),
    HomePage(),
    Favourites(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    final iconSize = Variables.responsiveIconSize(context, 30.0);

    return Scaffold(
      body: _pages[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Variables.greyBG, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showSelectedLabels: false, // Hides selected labels
          showUnselectedLabels: false, // Hides unselected labels
          iconSize: iconSize,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SvgPicture.asset(
                  _selectedIndex == 0
                      ? 'assets/icons/plane fill.svg'
                      : 'assets/icons/plane outline.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  _selectedIndex == 1
                      ? Icons.home_rounded
                      : Icons.home_outlined,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  _selectedIndex == 2 ? Icons.favorite : Icons.favorite_border,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  _selectedIndex == 3
                      ? Icons.settings
                      : Icons.settings_outlined,
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
