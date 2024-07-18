import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:quan_ly_ban_ca_phe/firebase_options.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/admin_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/home_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/welcome_page.dart';
import 'package:quan_ly_ban_ca_phe/views/auth/chosse_login_account_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android
  );
  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
    ),
  );
}

// void main()  => runApp(
//       DevicePreview(
//         enabled: !kReleaseMode,
//         builder: (context) => const MyApp(), // Wrap your app
//       ),
//     );

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.ios
//   );
//   runApp(
//     const MyApp()
//     );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      home: WelcomePage(),
      getPages: [
        GetPage(name: '/welcome_page', page: () => const WelcomePage()),
        // GetPage(name: '/introduce_page1', page: () => const IntroducePage1()),
        // GetPage(name: '/introduce_page2', page: () => const IntroducePage2()),
        GetPage(name: '/choose_login_account_page', page: () => ChooseLoginAccountPage()),
        // GetPage(name: '/auth_page', page: () => const AuthUserPage()),
        GetPage(name: '/home_page', page: () => const HomePage()),
        // GetPage(name: '/list_product_page', page:() => const ListProductPage()),
        // GetPage(name: '/product_popular_page', page:() => const ProductPopularPage()),
        // GetPage(name: '/favorite_product_page', page:() => const FavoriteProductPage()),
        // GetPage(name: '/cart_page', page:() => const CartPage()),
        // GetPage(name: '/bill_page', page:() => const BillPage()),
        GetPage(name: '/admin_page', page:() => const AdminPage()),
        // GetPage(name: '/update_user_profile_page', page:() => const UpdateUserProfilePage()),
        // GetPage(name: '/my_order_page', page:() => const MyOrderPage()),
      ],
      theme: ThemeData(
        primaryColor: light_yellow,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}