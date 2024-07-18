import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quan_ly_ban_ca_phe/views/admin/admin_page.dart';
import 'package:quan_ly_ban_ca_phe/views/auth/toggle/login_login_register_switcher_admin_page.dart';
import 'package:quan_ly_ban_ca_phe/views/auth/toggle/login_register_switcher_user_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/home_page.dart';

class AuthAdminPage extends StatefulWidget {
  const AuthAdminPage({Key? key}) : super(key: key);

  @override
  State<AuthAdminPage> createState() => _AuthAdminPageState();
}

class _AuthAdminPageState extends State<AuthAdminPage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginRegisterSwitcherAdminPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return AdminPage();
    } else {
      return LoginRegisterSwitcherAdminPage ();
    }
  }
  
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginRegisterSwitcherAdminPage()),
    );
  }
}
