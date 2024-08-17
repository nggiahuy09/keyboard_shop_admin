import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/services/firebase_services.dart';
import 'package:kb_shop_admin/widgets/product_widget.dart';

class ProductsGridWidget extends StatelessWidget {
  const ProductsGridWidget({
    super.key,
    required this.isInMain,
    this.crossAxisCount = 5,
    this.childAspectRatio = 1,
  });

  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fireStoreInstance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return GridView.builder(
              itemCount: isInMain && snapshot.data!.docs.length > 5 ? 5 : snapshot.data!.docs.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                mainAxisSpacing: defaultPadding,
                crossAxisSpacing: defaultPadding,
              ),
              itemBuilder: (context, index) {
                return ProductWidget(
                  productId: snapshot.data!.docs[index]['id'],
                );
              },
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Your Products List is Empty',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground,
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
