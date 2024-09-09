import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/responsive.dart';
import 'package:kb_shop_admin/services/utils.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({
    super.key,
    required this.imageUrl,
    required this.totalPrice,
    required this.quantity,
    required this.userName,
    required this.orderDate,
  });

  final String imageUrl, totalPrice, userName, quantity;
  final Timestamp orderDate;

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late final String _imageUrl, _totalPrice, _quantity, _userName, _orderDate;

  @override
  void initState() {
    _imageUrl = widget.imageUrl;
    _totalPrice = widget.totalPrice;
    _userName = widget.userName;
    _quantity = widget.quantity;
    _orderDate =
        '${widget.orderDate.toDate().day}/${widget.orderDate.toDate().month}/${widget.orderDate.toDate().year} - ${widget.orderDate.toDate().hour}:${widget.orderDate.toDate().minute}';

    super.initState();
  }

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
            Image.network(
              _imageUrl,
              width: Responsive.isMobile(context) ? size.width * 0.15 : size.width * 0.08,
            ),
            const SizedBox(width: defaultPadding * 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price: $_totalPrice',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: defaultPadding / 4),
                Text(
                  'Quantity: $_totalPrice',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: defaultPadding / 4),
                Text(
                  'By: $_userName',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: defaultPadding / 4),
                Text(
                  'Order Date: $_orderDate',
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
