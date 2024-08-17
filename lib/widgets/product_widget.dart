import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/responsive.dart';
import 'package:kb_shop_admin/services/firebase_services.dart';
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

  String title = '';
  String imageUrl = '';
  String category = '';
  String price = '0.0';
  String salePrice = '0.0';
  String quantity = '0';
  bool isOnSale = false;

  @override
  void initState() {
    super.initState();
    getProductInfor();
  }

  Future<void> getProductInfor() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final DocumentSnapshot documentSnapshot = await fireStoreInstance.collection('products').doc(widget.productId).get();
      if (documentSnapshot.exists) {
        title = documentSnapshot.get('title');
        imageUrl = documentSnapshot.get('image_url');
        category = documentSnapshot.get('category');
        price = documentSnapshot.get('price');
        salePrice = documentSnapshot.get('sale_price');
        quantity = documentSnapshot.get('quantity');
        isOnSale = documentSnapshot.get('isOnSale');

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } catch (err) {
      Utils.showToast(msg: err.toString());
      setState(() {
        _isLoading = false;
      });
    } finally {
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
      child: GestureDetector(
        onTap: () {},
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
                        onTap: () {},
                        value: 1,
                        child: const Text('Edit'),
                      ),
                      PopupMenuItem(
                        onTap: () {},
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
                    // Uri.decodeFull(imageUrl),
                    Uri.decodeFull("https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg"),
                    width: Responsive.isMobile(context) ? size.width * 0.15 : size.width * 0.08,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            // fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isOnSale ? salePrice.toString() : price.toString(),
                              style: TextStyle(
                                // fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                              ),
                            ),
                            if (isOnSale)
                              Text(
                                price.toString(),
                                style: TextStyle(
                                  // fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          category,
                          style: TextStyle(
                            // fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
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
      ),
    );
  }
}
