import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/app/home_page.dart';
import 'package:quan_ly_ban_ca_phe/widgets/my_button.dart';
import 'package:quan_ly_ban_ca_phe/widgets/text_form_field_email.dart';
import 'package:quan_ly_ban_ca_phe/widgets/text_form_field_password.dart';

class LoginUserWithEmailAndPasswordPage extends StatefulWidget {
  final Function()? onTap;
  const LoginUserWithEmailAndPasswordPage({super.key, required this.onTap});

  @override
  State<LoginUserWithEmailAndPasswordPage> createState() =>
      _LoginUserWithEmailAndPasswordPageState();
}

class _LoginUserWithEmailAndPasswordPageState
    extends State<LoginUserWithEmailAndPasswordPage> {
  final _emailController = TextEditingController();
  final _passWordController = TextEditingController();
  bool isLoggedIn = false;
  bool isObsecure = false;

  void loginUserEmail() async {
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

        QuerySnapshot users = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (users.docs.isNotEmpty) {
          String email = users.docs[0]['email'];
          Get.offAll(HomePage());
          showNotification(context, "Đăng nhập thành công với email: $email");
        } else {
          showNotification(context, "Có lỗi xảy ra");
        }
      } on FirebaseAuthException catch (e) {
        showNotification(context, "Email hoặc mật khẩu không chính xác");
      } catch (e) {
        showNotification(context, "Có lỗi xảy ra");
      }
    }
  }

  void dispose() {
    _emailController.text.trim();
    _passWordController.text.trim();

    super.dispose();
  }

  //
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
        padding: const EdgeInsets.only(left: 18.0, top: 70.0, right: 18.0),
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
            Text(
              'Màn hình  đăng nhập',
              style: GoogleFonts.arsenal(
                  fontSize: 30.0, fontWeight: FontWeight.bold, color: black),
            ),
            SizedBox(
              height: 190.0,
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
              text: 'Đăng nhập',
              onTap: loginUserEmail,
              buttonColor: green,
            ),
            SizedBox(
              height: 40.0,
            ),
            //or continue with
            // Row(
            //   children: [
            //     Expanded(
            //       child: Divider(
            //         thickness: 1,
            //         color: black,
            //       ),
            //     ),
            //     Text(
            //       '      hoặc      ',
            //       style: GoogleFonts.roboto(color: black),
            //     ),
            //     Expanded(
            //       child: Divider(
            //         thickness: 1,
            //         color: black,
            //       ),
            //     )
            //   ],
            // ),
            SizedBox(
              height: 50.0,
            ),
            //or login with facebook, email, google,...
            // Center(
            //     child: Text('ĐĂNG NHẬP BẰNG',
            //         style: GoogleFonts.roboto(color: black))),
            SizedBox(
              height: 20.0,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     LoginWithMore(imagePath: 'assets/icons/facebook.png'),
            //     LoginWithMore(imagePath: 'assets/icons/google.png'),
            //     LoginWithMore(imagePath: 'assets/icons/apple.png'),
            //   ],
            // ),
            SizedBox(
              height: 70,
            ),
            //text tip
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Chưa có tài khoản? ',
                    style: GoogleFonts.roboto(color: black)),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Đăng ký',
                    style: GoogleFonts.roboto(
                        color: blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
