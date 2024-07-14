import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
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
    return GridView.builder(
      itemCount: isInMain ? 5 : 10,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: defaultPadding,
        crossAxisSpacing: defaultPadding,
      ),
      itemBuilder: (context, index) {
        return const ProductWidget();
      },
    );
  }
}
