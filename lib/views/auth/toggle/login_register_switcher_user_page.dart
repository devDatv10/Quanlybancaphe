import 'package:flutter/material.dart';
import 'package:quan_ly_ban_ca_phe/views/user/login_user_with_email_and_password_page.dart';
import 'package:quan_ly_ban_ca_phe/views/user/register_user_with_email_and_password_page.dart.dart';

class LoginRegisterSwitcherUserPage extends StatefulWidget {
  const LoginRegisterSwitcherUserPage({super.key});

  @override
  State<LoginRegisterSwitcherUserPage> createState() => _LoginRegisterSwitcherUserPageState();
}

class _LoginRegisterSwitcherUserPageState extends State<LoginRegisterSwitcherUserPage> {
  bool showloginPage  = true;

  void togglePage(){
    setState(() {
      showloginPage = !showloginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showloginPage){
      return LoginUserWithEmailAndPasswordPage(onTap: togglePage);
    }else{
      return RegisterUserWithEmailAndPasswordPage(onTap: togglePage,);
    }
  }
}