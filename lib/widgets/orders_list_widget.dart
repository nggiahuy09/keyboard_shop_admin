import 'package:flutter/material.dart';
import 'package:kb_shop_admin/services/firebase_services.dart';
import 'package:kb_shop_admin/widgets/order_widget.dart';

class OrdersListWidget extends StatefulWidget {
  const OrdersListWidget({
    super.key,
    required this.isInMain,
  });

  final bool isInMain;

  @override
  State<OrdersListWidget> createState() => _OrdersListWidgetState();
}

class _OrdersListWidgetState extends State<OrdersListWidget> {
  late final bool _isInMain;

  @override
  void initState() {
    _isInMain = widget.isInMain;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fireStoreInstance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length > 5 && _isInMain
                  ? 5
                  : snapshot.data!.docs.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 4),
                    OrderWidget(
                      imageUrl: snapshot.data!.docs[index]['imageUrl'],
                      userName: snapshot.data!.docs[index]['userName'],
                      totalPrice: snapshot.data!.docs[index]['totalPrice'],
                      orderDate: snapshot.data!.docs[index]['orderDate'],
                      quantity: snapshot.data!.docs[index]['quantity'].toString(),
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Your Orders List is Empty',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onBackground,
                  ),
                ),
              ),
            );
          }
        }
        return const Center(
          child: Text('Something went wrong...'),
        );
      },
    );
  }
}
