import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quan_ly_ban_ca_phe/views/auth/toggle/login_register_switcher_user_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/home_page.dart';

class AuthUserPage extends StatefulWidget {
  const AuthUserPage({Key? key}) : super(key: key);

  @override
  State<AuthUserPage> createState() => _AuthUserPageState();
}

class _AuthUserPageState extends State<AuthUserPage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => LoginRegisterSwitcherUserPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return HomePage();
    } else {
      return LoginRegisterSwitcherUserPage();
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginRegisterSwitcherUserPage()),
    );
  }
}
