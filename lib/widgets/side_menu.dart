import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kb_shop_admin/provider/dark_theme_provider.dart';
import 'package:kb_shop_admin/screens/main_page.dart';
import 'package:kb_shop_admin/services/utils.dart';
import 'package:provider/provider.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({
    super.key,
  });

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetSate();
}

class _SideMenuWidgetSate extends State<SideMenuWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);
    // final color = Utils(context).color;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              "assets/images/groceries.png",
            ),
          ),
          DrawerListTileWidget(
            title: "Main",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
            icon: Icons.home_filled,
          ),
          DrawerListTileWidget(
            title: "View all product",
            press: () {},
            icon: Icons.store,
          ),
          DrawerListTileWidget(
            title: "View all order",
            press: () {},
            icon: IconlyBold.bag_2,
          ),
          SwitchListTile(
              title: const Text('Theme'),
              secondary: Icon(themeState.getDarkTheme ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
              value: theme,
              onChanged: (value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              })
        ],
      ),
    );
  }
}

class DrawerListTileWidget extends StatelessWidget {
  const DrawerListTileWidget({
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.press,
    required this.icon,
  });

  final String title;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;

    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        size: 18,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }
}
