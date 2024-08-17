import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/controllers/menu_controller.dart';
import 'package:kb_shop_admin/model/product_model.dart';
import 'package:kb_shop_admin/responsive.dart';
import 'package:kb_shop_admin/services/firebase_services.dart';
import 'package:kb_shop_admin/services/utils.dart';
import 'package:kb_shop_admin/services/uuid_services.dart';
import 'package:kb_shop_admin/widgets/button.dart';
import 'package:kb_shop_admin/widgets/custom_widget/cus_loading_widget.dart';
import 'package:kb_shop_admin/widgets/header.dart';
import 'package:kb_shop_admin/widgets/input_field_widget.dart';
import 'package:kb_shop_admin/widgets/side_menu.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _editGlobalKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  ProductModel? product;

  File? _pickedImage;
  Uint8List? _webImage = Uint8List(10);
  bool _isLoading = false;
  String _categoryValue = 'Keyboard';
  String _imageUrl = 'assets/images/empty_image.png';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    if (!kIsWeb) {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selectedImage = File(image.path);
        setState(() {
          _pickedImage = selectedImage;
        });
      }
    } else {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var imageBytes = await image.readAsBytes();
        setState(() {
          _webImage = imageBytes;
          _pickedImage = File('file');
        });
      }
    }
  }

  void _updateProduct() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    final isValid = _editGlobalKey.currentState!.validate();
    if (isValid) {
      _editGlobalKey.currentState!.save();

      final ref = fireStorageInstance.ref().child('ProductImages').child('_$uuidV4.jpg');

      if (kIsWeb) {
        await ref.putData(_webImage!);
      } else {
        await ref.putFile(_pickedImage!);
      }

      final imageUrl = await ref.getDownloadURL();

      try {
        await fireStoreInstance.collection('products').doc(widget.productId).set({
          'id': widget.productId,
          'title': _titleController.text.trim(),
          'price': _priceController.text.trim(),
          'sale_price': _salePriceController.text.trim().isEmpty ? '0.0' : _salePriceController.text.trim(),
          'image_url': imageUrl,
          'category': _categoryValue,
          'isOnSale': _salePriceController.text.trim().isNotEmpty,
          'quantity': _quantityController.text.trim(),
          'last_modify': Timestamp.now(),
        });

        Utils.showToast(msg: 'Update Product Successfully');
        _clearForm();

        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        Utils.showToast(
          msg: err.toString(),
        );

        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _titleController.clear();
    _priceController.clear();
    _quantityController.clear();
    _salePriceController.clear();
    _pickedImage = null;
    _webImage = null;
    _imageUrl = 'assets/images/empty_image.png';
  }

  void getProductInformation() async {
    setState(() {
      _isLoading = true;
    });

    product = await Utils.getProductInfor(productId: widget.productId);

    if (product != null) {
      setState(() {
        _isLoading = false;
        _categoryValue = product!.category;
        _titleController.text = product!.title;
        _priceController.text = product!.price;
        _quantityController.text = product!.quantity;
        _salePriceController.text = product!.salePrice;
        _imageUrl = product!.imageUrl;
      });
    } else {
      Utils.showToast(msg: 'Occur Error When Getting Product Information');
      setState(() {
        _isLoading = false;
        _titleController.text = 'null';
        _priceController.text = 'null';
        _quantityController.text = 'null';
        _salePriceController.text = 'null';
      });
    }
  }

  @override
  void initState() {
    getProductInformation();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    final scaffoldColor = Theme.of(context).primaryColor.withOpacity(0.15);

    Size size = Utils(context).getScreenSize;

    return Scaffold(
      key: context.read<MenuControllers>().addProductScaffoldKey,
      drawer: const SideMenuWidget(),
      body: CusLoadingWidget(
        isLoading: _isLoading,
        child: Row(
          children: [
            if (Responsive.isDesktop(context)) const Expanded(child: SideMenuWidget()),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HeaderWidget(
                        fct: () => context.read<MenuControllers>().controlAddProductMenu(),
                        title: 'Edit Product',
                        isAllowSearch: false,
                      ),
                      Container(
                        width: size.width > 650 ? 650 : size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                        margin: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _editGlobalKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InputField(
                                title: 'Product Title(*)',
                                textEditingController: _titleController,
                                scaffoldColor: scaffoldColor,
                                borderSideColor: color,
                                validate: (value) => value!.isEmpty ? 'Title is missed!' : null,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Category',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.onBackground,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: scaffoldColor,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _categoryValue,
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: 'Keyboard',
                                                      child: Text(
                                                        'Keyboard',
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onBackground,
                                                        ),
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Gaming Mouse',
                                                      child: Text(
                                                        'Gaming Mouse',
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onBackground,
                                                        ),
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Keycap',
                                                      child: Text(
                                                        'Keycap',
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.onBackground,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      _categoryValue = value!;
                                                      if (product != null) {
                                                        product!.category = value;
                                                      }
                                                    });
                                                  },
                                                  hint: const Text('Select a category'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        InputField(
                                          title: 'Price in \$(*)',
                                          textEditingController: _priceController,
                                          scaffoldColor: scaffoldColor,
                                          borderSideColor: color,
                                          validate: (value) => value!.isEmpty ? 'Price is missed!' : null,
                                          inputFormatter: <TextInputFormatter>[
                                            Utils(context).numberInputFormatter,
                                          ],
                                        ),
                                        const SizedBox(height: 16),

                                        InputField(
                                          title: 'Sale Price',
                                          textEditingController: _salePriceController,
                                          scaffoldColor: scaffoldColor,
                                          borderSideColor: color,
                                          validate: (value) => null,
                                          inputFormatter: <TextInputFormatter>[
                                            Utils(context).numberInputFormatter,
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        // drop down category

                                        InputField(
                                          title: 'Quantity(*)',
                                          textEditingController: _quantityController,
                                          scaffoldColor: scaffoldColor,
                                          borderSideColor: color,
                                          validate: (value) => value!.isEmpty ? 'Quantity is missed!' : null,
                                          inputFormatter: <TextInputFormatter>[
                                            Utils(context).numberInputFormatter,
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: _pickImage,
                                          child: SizedBox(
                                            width: size.width > 650 ? 200 : size.width,
                                            height: 200,
                                            child: _pickedImage != null
                                                ? kIsWeb
                                                    ? DottedBorder(
                                                        child: Center(child: Image.memory(_webImage!)),
                                                      )
                                                    : DottedBorder(
                                                        child: Center(child: Image.file(_pickedImage!)),
                                                      )
                                                : Image.network(_imageUrl),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextButton(
                                          onPressed: _pickImage,
                                          child: Text(
                                            'Update',
                                            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonWidget(
                                    onPressed: () => Utils.deleteProduct(
                                      context: context,
                                      productId: widget.productId,
                                    ),
                                    text: 'Delete',
                                    icon: Icons.delete,
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  ButtonWidget(
                                    onPressed: _updateProduct,
                                    text: 'Update Product',
                                    icon: Icons.update,
                                    backgroundColor: Theme.of(context).primaryColor,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
