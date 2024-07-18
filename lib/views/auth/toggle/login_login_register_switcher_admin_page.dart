import 'package:flutter/material.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/login_admin_with_email_and_password_page.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/register_admin_with_email_and_password_page.dart';

class LoginRegisterSwitcherAdminPage extends StatefulWidget {
  const LoginRegisterSwitcherAdminPage({Key? key}) : super(key: key);

  @override
  _LoginRegisterSwitcherPageAdminState createState() =>
      _LoginRegisterSwitcherPageAdminState();
}

class _LoginRegisterSwitcherPageAdminState extends State<LoginRegisterSwitcherAdminPage> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: showLoginPage
            ? LoginAdminWithEmailAndPassWordPage(onTap: togglePage)
            : LoginAdminWithEmailAndPassWordPage(onTap: togglePage),
      ),
    );
  }
}