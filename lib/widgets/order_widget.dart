import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/responsive.dart';
import 'package:kb_shop_admin/services/utils.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/groceries.png',
              width: Responsive.isMobile(context) ? size.width * 0.15 : size.width * 0.08,
            ),
            const SizedBox(width: defaultPadding * 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: defaultPadding / 4),
                Text(
                  'By UserName',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: defaultPadding / 4),
                Text(
                  '14/07/2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
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
