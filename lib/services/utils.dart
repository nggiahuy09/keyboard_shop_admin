import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kb_shop_admin/model/product_model.dart';
import 'package:kb_shop_admin/provider/dark_theme_provider.dart';
import 'package:kb_shop_admin/services/firebase_services.dart';
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

  static Future<ProductModel?> getProductInfor({required String productId}) async {
    final ProductModel product;

    try {
      final DocumentSnapshot documentSnapshot = await fireStoreInstance.collection('products').doc(productId).get();
      if (documentSnapshot.exists) {
        product = ProductModel(
          title: documentSnapshot.get('title'),
          imageUrl: documentSnapshot.get('image_url'),
          category: documentSnapshot.get('category'),
          price: documentSnapshot.get('price'),
          quantity: documentSnapshot.get('quantity'),
          salePrice: documentSnapshot.get('sale_price'),
          isOnSale: documentSnapshot.get('isOnSale'),
        );

        return product;
      } else {
        return null;
      }
    } catch (err) {
      Utils.showToast(msg: err.toString());
      return null;
    }
  }
}
