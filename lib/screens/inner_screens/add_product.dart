import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/controllers/menu_controller.dart';
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

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _addProductKey = GlobalKey<FormState>();

  late final TextEditingController _titleController, _priceController, _quantityController, _salePriceController;

  String _categoryValue = 'Keyboard';
  File? _pickedImage;
  Uint8List? _webImage;
  bool _isLoading = false;

  void _uploadProduct() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    final isValid = _addProductKey.currentState!.validate();
    if (isValid) {
      _addProductKey.currentState!.save();

      if (_pickedImage == null) {
        Utils.showToast(msg: 'Please Pick up an Image');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final ref = fireStorageInstance.ref().child('ProductImages').child('_$uuidV4.jpg');

      if (kIsWeb) {
        await ref.putData(_webImage!);
      } else {
        await ref.putFile(_pickedImage!);
      }

      final imageUrl = await ref.getDownloadURL();

      try {
        await fireStoreInstance.collection('products').doc(uuidV4).set({
          'id': uuidV4,
          'title': _titleController.text.trim(),
          'price': _priceController.text.trim(),
          'sale_price': _salePriceController.text.trim().isEmpty ? '0.0': _salePriceController.text.trim(),
          'image_url': imageUrl,
          'category': _categoryValue,
          'isOnSale': _salePriceController.text.trim().isNotEmpty,
          'quantity': _quantityController.text.trim(),
          'last_modify': Timestamp.now(),
        });

        Utils.showToast(msg: 'Add Product Successfully');
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

  @override
  void initState() {
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _salePriceController = TextEditingController();
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

  void _clearForm() {
    _titleController.clear();
    _priceController.clear();
    _quantityController.clear();
    _salePriceController.clear();
    _pickedImage = null;
    _webImage = null;
  }

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
                        title: 'Add Product',
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
                          key: _addProductKey,
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
                                                : DottedBorder(
                                                    strokeWidth: 1.5,
                                                    color: Theme.of(context).colorScheme.onBackground,
                                                    radius: const Radius.circular(16),
                                                    dashPattern: const [4, 2],
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          const Icon(Icons.image, size: 40),
                                                          Text(
                                                            'Pick an Image',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,
                                                              color: Theme.of(context).colorScheme.onBackground,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              child: const Text(
                                                'Remove',
                                                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _pickedImage = null;
                                                  _webImage = null;
                                                });
                                              },
                                            ),
                                            TextButton(
                                              onPressed: _pickImage,
                                              child: Text(
                                                'Upload',
                                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
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
                                    onPressed: _clearForm,
                                    text: 'Clear Form',
                                    icon: Icons.warning,
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  ButtonWidget(
                                    onPressed: _uploadProduct,
                                    text: 'Add Product',
                                    icon: Icons.upload,
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


