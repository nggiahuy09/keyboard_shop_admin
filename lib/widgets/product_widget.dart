import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/model/product_model.dart';
import 'package:kb_shop_admin/responsive.dart';
import 'package:kb_shop_admin/screens/inner_screens/edit_product.dart';
import 'package:kb_shop_admin/services/utils.dart';
import 'package:kb_shop_admin/widgets/custom_widget/cus_loading_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  bool _isLoading = false;

  String _imageUrl = 'assets/images/empty_image.png';
  ProductModel? product;

  @override
  void initState() {
    getProductInformation();
    super.initState();
  }

  void getProductInformation() async {
    setState(() {
      _isLoading = true;
    });

    product = await Utils.getProductInfor(productId: widget.productId);

    if (product != null) {
      setState(() {
        _isLoading = false;
        _imageUrl = product!.imageUrl;
      });
    } else {
      Utils.showToast(msg: 'Occur Error When Getting Product Information');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    return CusLoadingWidget(
      isLoading: _isLoading,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding / 2,
          vertical: defaultPadding,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/dashboard/edit_product',
                        arguments: widget.productId,
                      ),
                      value: 1,
                      child: const Text('Edit'),
                    ),
                    PopupMenuItem(
                      onTap: () => Utils.deleteProduct(
                        context: context,
                        productId: widget.productId,
                      ),
                      value: 2,
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ];
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  _imageUrl,
                  width: Responsive.isMobile(context)
                      ? size.width * 0.15
                      : size.width * 0.08,
                  height: Responsive.isMobile(context)
                      ? size.width * 0.15
                      : size.width * 0.08,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product != null ? product!.title : 'null',
                        style: TextStyle(
                          // fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product != null
                                ? product!.isOnSale
                                    ? 'Price (\$): ${product!.salePrice.toString()}'
                                    : 'Price (\$): ${product!.price.toString()}'
                                : 'null',
                            style: TextStyle(
                              // fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.7),
                            ),
                          ),
                          if (product != null ? product!.isOnSale : false)
                            Text(
                              product!.price.toString(),
                              style: TextStyle(
                                // fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        product != null
                            ? 'Category: ${product!.category}'
                            : 'null',
                        style: TextStyle(
                          // fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
