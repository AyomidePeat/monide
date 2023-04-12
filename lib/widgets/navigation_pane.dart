import 'package:flutter/material.dart';
import 'package:road_mechanic/constants/colors.dart';

class MenuStuffs {
  final String title;
  final IconData icon;

  const MenuStuffs({required this.title, required this.icon});
}

class MenuItems {
  static const home = MenuStuffs(title: 'Home', icon: Icons.home);
  static const info =
      MenuStuffs(title: 'How MoniDe works', icon: Icons.lightbulb_sharp);
  static const money = MenuStuffs(
      title: 'Make money From MoniDe', icon: Icons.monetization_on_outlined);
  static const notifications =
      MenuStuffs(title: "Notifications", icon: Icons.notifications);
  static const refer =
      MenuStuffs(title: 'Invite a friend', icon: Icons.celebration);
  static const feedback =
      MenuStuffs(title: 'Got a complain?', icon: Icons.chat);
  static const rateUs = MenuStuffs(title: "Rate Us", icon: Icons.rate_review);

  static const all = <MenuStuffs>[
    home,
    info,
    money,
    notifications,
    refer,
    feedback,
    rateUs
  ];
}

class NavigationPane extends StatelessWidget {
  final MenuStuffs currentItem;
  final ValueChanged<MenuStuffs> onSelectedItem;
  const NavigationPane(
      {required this.currentItem, required this.onSelectedItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.from(colorScheme: bluemode),
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                ...MenuItems.all.map(buildMenuItems).toList(),
                Spacer(flex: 2),
              ],
            ),
          ),
        ));
  }
   Widget buildMenuItems(MenuStuffs item) => ListTileTheme(
        selectedColor: Colors.white,
        child: ListTile(
          selectedTileColor: Colors.black26,
          selected: currentItem == item,
          minLeadingWidth: 20,
          leading: Icon(item.icon),
          title: Text(item.title),
          onTap: () {
            onSelectedItem(item);
          },
        ),
      );
}


