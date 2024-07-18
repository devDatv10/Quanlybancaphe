import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/widgets/my_button.dart';
import 'package:quan_ly_ban_ca_phe/widgets/text_form_field_email.dart';
import 'package:quan_ly_ban_ca_phe/widgets/text_form_field_password.dart';

class LoginAdminWithEmailAndPassWordPage extends StatefulWidget {
  final Function()? onTap;
  const LoginAdminWithEmailAndPassWordPage({super.key, required this.onTap});

  @override
  State<LoginAdminWithEmailAndPassWordPage> createState() =>
      _LoginAdminWithEmailAndPassWordPageState();
}

class _LoginAdminWithEmailAndPassWordPageState
    extends State<LoginAdminWithEmailAndPassWordPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _emailController = TextEditingController();
  final _passWordController = TextEditingController();
  bool isObsecure = false;
  
  void loginAdminEmail() async {
    String email = _emailController.text.trim();
    String password = _passWordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showNotification(context, "Đăng nhập không hợp lệ, vui lòng thử lại");
    } else if (password.length < 6) {
      showNotification(context, "Mật khẩu phải có ít nhất 6 kí tự");
    } else {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        QuerySnapshot admins = await FirebaseFirestore.instance
            .collection('Admins')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (admins.docs.isNotEmpty) {
          String adminName = admins.docs[0]['email'];
          Navigator.pushReplacementNamed(context, '/admin_page');
          showNotification(
              context, "Đăng nhập thành công với email: $adminName");
        } else {
          showNotification(context, "Đăng nhập thất bại");
        }
      } on FirebaseAuthException catch (e) {
        showNotification(context, "Email hoặc mật khẩu không chính xác");
      }
    }
  }

  void showNotification(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.roboto(
              color: blue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK", style: TextStyle(color: blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.only(
            left: 18.0, top: 60.0, right: 18.0, bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 30,
                    )),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Đăng nhập Admin',
                style: GoogleFonts.arsenal(
                    fontSize: 30.0, fontWeight: FontWeight.bold, color: blue),
              ),
            ),
            SizedBox(
              height: 150.0,
            ),
            //form email
            TextFormFieldEmail(
              hintText: 'Email',
              prefixIconData: Icons.email,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _emailController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: grey,
                  )),
              controller: _emailController,
              iconColor: grey,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form password
            TextFormFieldPassword(
              hintText: 'Nhập mật khẩu',
              prefixIconData: Icons.vpn_key_sharp,
              suffixIcon: IconButton(
                icon: Icon(
                  isObsecure ? Icons.visibility : Icons.visibility_off,
                  color: grey,
                ),
                onPressed: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
              ),
              controller: _passWordController,
              iconColor: grey,
              obscureText: !isObsecure,
            ),
            SizedBox(
              height: 20.0,
            ),
            //edit password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Quên mật khẩu?',
                  style: GoogleFonts.roboto(
                      color: blue, decoration: TextDecoration.underline),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            //button login
            MyButton(
                text: 'Đăng nhập', onTap: loginAdminEmail, buttonColor: green),
            SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
