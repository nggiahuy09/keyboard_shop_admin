import 'package:flutter/material.dart';

class MenuControllers extends ChangeNotifier {
   MenuControllers();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _gridScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _addProductScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _ordersScaffoldKey = GlobalKey<ScaffoldState>();

  // getters
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  GlobalKey<ScaffoldState> get gridScaffoldKey => _gridScaffoldKey;
  GlobalKey<ScaffoldState> get addProductScaffoldKey => _addProductScaffoldKey;
  GlobalKey<ScaffoldState> get ordersScaffoldKey => _ordersScaffoldKey;

  // callbacks
  void controlDashboardMenu() {
    if(!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void controlProductsMenu() {
    if(!_gridScaffoldKey.currentState!.isDrawerOpen) {
      _gridScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlOrdersMenu() {
    if(!_ordersScaffoldKey.currentState!.isDrawerOpen) {
      _ordersScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAddProductMenu() {
    if(!_addProductScaffoldKey.currentState!.isDrawerOpen) {
      _addProductScaffoldKey.currentState!.openDrawer();
    }
  }

}