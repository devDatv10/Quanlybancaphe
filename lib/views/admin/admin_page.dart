import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/add_category_page.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/add_product_page.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/dashboard_page.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/delete_category_page.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/delete_product_page.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/revenue_page.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/update_category_page.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/update_product_page.dart';
import 'package:quan_ly_ban_ca_phe/views/auth/chosse_login_account_page.dart';
import 'package:quan_ly_ban_ca_phe/widgets/notification_dialog.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  //
  Widget _selectedItem = DashboardPage();

  screenSlector(item) {
    switch (item.route) {
      case DashboardPage.routeName:
        setState(() {
          _selectedItem = DashboardPage();
        });

        break;

      case RevenuePage.routeName:
        setState(() {
          _selectedItem = RevenuePage();
        });

        break;

      case AddCategoryPage.routeName:
        setState(() {
          _selectedItem = AddCategoryPage();
        });

      case DeleteCategoryPage.routeName:
        setState(() {
          _selectedItem = DeleteCategoryPage();
        });

      case UpdateCategoryPage.routeName:
        setState(() {
          _selectedItem = UpdateCategoryPage();
        });

      case AddProductPage.routeName:
        setState(() {
          _selectedItem = AddProductPage();
        });

        break;

      case DeleteProductPage.routeName:
        setState(() {
          _selectedItem = DeleteProductPage();
        });

        break;

      case UpdateProductPage.routeName:
        setState(() {
          _selectedItem = UpdateProductPage();
        });
    }
  }

  void _showConfirmExit() {
    notificationDialog(
      context: context,
      title: 'Thông báo',
      message: "Đăng xuất khỏi tài khoản của bạn?",
      onConfirm: () {},
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Hủy", style: TextStyle(color: red)),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ChooseLoginAccountPage()),
              (Route<dynamic> route) => false,
            );
          },
          child: Text("Đồng ý", style: TextStyle(color: blue)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        backgroundColor: background,
        appBar: AppBar(
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {
                    _showConfirmExit();
                  }, icon: Icon(Icons.logout)),
            )
          ],
          backgroundColor: Colors.transparent,
          title: Text(
            'TRANG ADMIN',
            style: GoogleFonts.arsenal(
                color: blue, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        sideBar: SideBar(
          iconColor: blue,
          activeIconColor: blue,
          items: [
            AdminMenuItem(
                title: 'Tổng quan',
                icon: Icons.dashboard,
                route: DashboardPage.routeName,
                children: [
                  AdminMenuItem(
                      title: 'Doanh số bán hàng',
                      route: RevenuePage.routeName,
                      icon: Icons.monetization_on_outlined),
                ]),
            //manager category
            AdminMenuItem(
              title: 'Danh mục',
              icon: Icons.category,
              children: [
                AdminMenuItem(
                    title: 'Thêm danh mục',
                    route: AddCategoryPage.routeName,
                    icon: Icons.add),
                AdminMenuItem(
                    title: 'Xóa danh mục',
                    route: DeleteCategoryPage.routeName,
                    icon: Icons.remove),
                AdminMenuItem(
                    title: 'Sửa danh mục',
                    route: UpdateCategoryPage.routeName,
                    icon: Icons.edit),
              ],
            ),
            //manager product
            AdminMenuItem(
              title: 'Sản phẩm',
              icon: Icons.local_cafe,
              children: [
                AdminMenuItem(
                    title: 'Thêm sản phẩm',
                    route: AddProductPage.routeName,
                    icon: Icons.add),
                AdminMenuItem(
                    title: 'Xóa sản phẩm',
                    route: DeleteProductPage.routeName,
                    icon: Icons.remove),
                AdminMenuItem(
                    title: 'Sửa sản phẩm',
                    route: UpdateProductPage.routeName,
                    icon: Icons.edit),
              ],
            ),
            AdminMenuItem(
              title: 'Đăng xuất',
              icon: Icons.logout,
            ),
          ],
          selectedRoute: '',
          onSelected: (item) {
            screenSlector(item);
          },
          header: Container(
            height: 50,
            width: double.infinity,
            color: brown,
            child: const Center(
              child: Text(
                'Quản lý bán cà phê',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: _selectedItem);
  }
}
