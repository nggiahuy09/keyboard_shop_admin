import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  static void showToast({
    required String msg,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity toastGravity = ToastGravity.BOTTOM,
    Color background = Colors.red,
    Color text = Colors.black12,
    double fontSize = 16.0,
  }) async {
    await Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: toastGravity,
      timeInSecForIosWeb: 1,
      backgroundColor: background,
      textColor: text,
      fontSize: fontSize,
    );
  }
}
