import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/controllers/menu_controller.dart';
import 'package:kb_shop_admin/responsive.dart';
import 'package:kb_shop_admin/services/utils.dart';
import 'package:kb_shop_admin/widgets/grid_products.dart';
import 'package:kb_shop_admin/widgets/header.dart';
import 'package:kb_shop_admin/widgets/side_menu.dart';
import 'package:provider/provider.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuControllers>().gridScaffoldKey,
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
    Size size = Utils(context).getScreenSize;

    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              fct: () => context.read<MenuControllers>().controlProductsMenu(),
              title: 'All Products',
              isAllowPop: false,
            ),
            const SizedBox(height: defaultPadding),
            Responsive(
              mobile: ProductsGridWidget(
                isInMain: false,
                crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                childAspectRatio: Responsive.isMobile(context) ? 1.1 : 0.9,
              ),
              desktop: ProductsGridWidget(
                isInMain: false,
                childAspectRatio: size.width < 1400 ? 0.7 : 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
