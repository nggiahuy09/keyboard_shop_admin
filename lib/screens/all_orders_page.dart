import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/controllers/menu_controller.dart';
import 'package:kb_shop_admin/responsive.dart';
import 'package:kb_shop_admin/widgets/header.dart';
import 'package:kb_shop_admin/widgets/orders_list_widget.dart';
import 'package:kb_shop_admin/widgets/side_menu.dart';
import 'package:provider/provider.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuControllers>().ordersScaffoldKey,
      drawer: const SideMenuWidget(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenuWidget(),
              ),
            const Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: AllProductsWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class AllProductsWidget extends StatefulWidget {
  const AllProductsWidget({super.key});

  @override
  State<AllProductsWidget> createState() => _AllProductsWidgetState();
}

class _AllProductsWidgetState extends State<AllProductsWidget> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              fct: () => context.read<MenuControllers>().controlOrdersMenu(),
              title: 'All Orders',
              isAllowSearch: false,
              isAllowPop: false,
            ),
            const SizedBox(height: defaultPadding),
            const OrdersListWidget(),
          ],
        ),
      ),
    );
  }
}
