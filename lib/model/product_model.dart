class ProductModel {
  String title;
  String imageUrl;
  String category;
  String price;
  String salePrice;
  String quantity;
  bool isOnSale;

  ProductModel({
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.price,
    this.salePrice = '0.0',
    required this.quantity,
    this.isOnSale = false,
  });
}
