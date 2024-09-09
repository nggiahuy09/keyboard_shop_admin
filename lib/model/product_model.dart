class ProductModel {
  String title;
  String imageUrl;
  String category;
  String price;
  String salePrice;
  String quantity;
  String productInfo;
  bool isOnSale;

  ProductModel({
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.quantity,
    required this.productInfo,
    this.salePrice = '0.0',
    this.isOnSale = false,
  });
}
