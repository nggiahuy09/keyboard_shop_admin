import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kb_shop_admin/provider/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class Utils {
  BuildContext context;

  Utils(this.context);

  bool get getTheme => Provider.of<DarkThemeProvider>(context).getDarkTheme;

  Color get color => getTheme ? Colors.white : Colors.black;

  Size get getScreenSize => MediaQuery.of(context).size;

  TextInputFormatter get numberInputFormatter => FilteringTextInputFormatter.allow(
        RegExp(r'[0-9.]'),
      );
}
