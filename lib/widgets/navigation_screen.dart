import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:road_mechanic/widgets/navigation_pane.dart';

import '../screens/feedback_screen.dart';
import '../screens/home_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.home:
        return HomeScreen();
      case MenuItems.feedback:
        return FeedBackScreen();
      //   case MenuItems.info:
      //     return InfoScreen();
      //   case MenuItems.notifications:
      //     return NotificationScreen();
      //   case MenuItems.money:
      //     return MakeMoneyScreen();
      //   case MenuItems.rateUs:
      //     return RateUsScreen();
      //     case MenuItems.refer
      //      return ReferAndEarnScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ZoomDrawer(
            borderRadius: 40,
            angle: -10,
            controller: drawerController,
            style: DrawerStyle.defaultStyle,
            slideWidth: MediaQuery.of(context).size.width * 0.8,
            showShadow: true,
            menuBackgroundColor: Colors.white,
            mainScreen: getScreen(),
            menuScreen: Builder(builder: (context) {
              return Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: NavigationPane(
                      currentItem: currentItem,
                      onSelectedItem: (item) {
                        setState(() => currentItem = item);
                        ZoomDrawer.of(context)?.close();
                      }));
            })));
  }

  MenuStuffs currentItem = MenuItems.home;
  ZoomDrawerController drawerController = ZoomDrawerController();
}
