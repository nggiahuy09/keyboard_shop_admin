import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kb_shop_admin/provider/dark_theme_provider.dart';
import 'package:kb_shop_admin/screens/all_orders_page.dart';
import 'package:kb_shop_admin/screens/all_products_page.dart';
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
              "assets/icons/app_icon.png",
            ),
          ),
          DrawerListTileWidget(
            title: "Dashboard",
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
            title: "View all products",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AllProductsScreen(),
                ),
              );
            },
            icon: Icons.store,
          ),
          DrawerListTileWidget(
            title: "View all orders",
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AllOrdersScreen(),
                ),
              );
            },
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
    return ListTile(
      onTap: press,
      horizontalTitleGap: 8.0,
      leading: Icon(
        icon,
        size: 20,
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}
