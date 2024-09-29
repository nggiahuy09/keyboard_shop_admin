import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kb_shop_admin/firebase_options.dart';
import 'package:kb_shop_admin/provider/dark_theme_provider.dart';
import 'package:kb_shop_admin/screens/all_orders_page.dart';
import 'package:kb_shop_admin/screens/all_products_page.dart';
import 'package:kb_shop_admin/screens/inner_screens/add_product.dart';
import 'package:kb_shop_admin/screens/inner_screens/edit_product.dart';
import 'package:kb_shop_admin/screens/main_page.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'package:kb_shop_admin/controllers/menu_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MenuControllers(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'KB Shop Admin',
            theme: Styles.themeData(themeProvider.getDarkTheme, context),
            initialRoute: '/dashboard',
            routes: {
              '/dashboard': (context) => const MainScreen(),
              '/all_orders': (context) => const AllOrdersScreen(),
              '/all_products': (context) => const AllProductsScreen(),
              '/dashboard/add_product': (context) => const AddProductScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/dashboard/edit_product') {
                final String productId = settings.arguments as String;

                return MaterialPageRoute(
                  builder: (context) => EditProductScreen(
                    productId: productId,
                  ),
                );
              }

              return null;
            },
          );
        },
      ),
    );
  }
}
