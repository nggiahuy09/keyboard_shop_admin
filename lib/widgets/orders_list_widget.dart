import 'package:flutter/material.dart';
import 'package:kb_shop_admin/widgets/order_widget.dart';

class OrdersListWidget extends StatefulWidget {
  const OrdersListWidget({super.key});

  @override
  State<OrdersListWidget> createState() => _OrdersListWidgetState();
}

class _OrdersListWidgetState extends State<OrdersListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const Column(
          children: [
            SizedBox(height: 4),
            OrderWidget(),
          ],
        );
      },
    );
  }
}
