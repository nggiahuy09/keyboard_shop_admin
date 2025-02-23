import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/controllers/menu_controller.dart';
import 'package:kb_shop_admin/responsive.dart';
import 'package:kb_shop_admin/services/utils.dart';
import 'package:kb_shop_admin/widgets/button.dart';
import 'package:kb_shop_admin/widgets/grid_products.dart';
import 'package:kb_shop_admin/widgets/header.dart';
import 'package:kb_shop_admin/widgets/orders_list_widget.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            HeaderWidget(
              title: 'Dashboard',
              fct: () => context.read<MenuControllers>().controlDashboardMenu(),
              isAllowPop: false,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Latest Products',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          Row(
                            children: [
                              ButtonWidget(
                                onPressed: () => Navigator.pushNamed(context, '/all_products'),
                                text: 'View All',
                                icon: Icons.store,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              const Spacer(),
                              ButtonWidget(
                                onPressed: () => Navigator.pushNamed(context, '/dashboard/add_product'),
                                text: 'Add New',
                                icon: Icons.plus_one,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: defaultPadding),
                      Responsive(
                        mobile: ProductsGridWidget(
                          isInMain: true,
                          crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                          childAspectRatio: Responsive.isMobile(context) ? 1.1 : 0.9,
                        ),
                        desktop: ProductsGridWidget(
                          isInMain: true,
                          childAspectRatio: size.width < 1400 ? 0.7 : 0.8,
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                      Text(
                        'Latest Orders (5 newest)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const OrdersListWidget(
                        isInMain: true,
                      ),
                      // MyProductsHome(),
                      // SizedBox(height: defaultPadding),
                      // OrdersScreen(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
