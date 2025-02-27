import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/widgets/my_button.dart';
import 'package:quan_ly_ban_ca_phe/widgets/text_form_field_email.dart';
import 'package:quan_ly_ban_ca_phe/widgets/text_form_field_password.dart';

class RegisterAdminWithEmailAndPasswordPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterAdminWithEmailAndPasswordPage({Key? key, required this.onTap})
      : super(key: key);

  @override
  _RegisterAdminWithEmailAndPasswordPageState createState() =>
      _RegisterAdminWithEmailAndPasswordPageState();
}

class _RegisterAdminWithEmailAndPasswordPageState
    extends State<RegisterAdminWithEmailAndPasswordPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isObsecure = false;

  void registerAdmin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showEmptyFieldsAlert();
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('Admins')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'passWord': password,
        });

        showSuccessAlert("Đăng ký thành công với email: $email");

        Navigator.pushReplacementNamed(context, '/admin_page');
      }
      showSuccessAlert("Đăng ký thành công với email: $email");
    } catch (e) {
      print("Error creating admin account: $e");
    }
  }

  void showSuccessAlert(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.arsenal(
              color: blue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
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

  //
  void showEmptyFieldsAlert() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("Thông báo",
              style: GoogleFonts.arsenal(
                  color: blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          content: Text("Đăng ký không hợp lệ, vui lòng thử lại"),
          actions: [
            CupertinoDialogAction(
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
            left: 18.0, top: 120.0, right: 18.0, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đăng ký Admin',
              style: GoogleFonts.arsenal(
                  fontSize: 30.0, fontWeight: FontWeight.bold, color: brown),
            ),
            SizedBox(
              height: 150.0,
            ),
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
                    color: blue,
                  )),
              controller: _emailController,
              iconColor: blue,
            ),
            SizedBox(height: 20.0),
            TextFormFieldPassword(
              hintText: 'Nhập mật khẩu',
              prefixIconData: Icons.vpn_key_sharp,
              suffixIcon: IconButton(
                icon: Icon(
                  isObsecure ? Icons.visibility : Icons.visibility_off,
                  color: blue,
                ),
                onPressed: () {
                  setState(() {
                    isObsecure = !isObsecure;
                  });
                },
              ),
              controller: _passwordController,
              iconColor: blue,
              obscureText: !isObsecure,
            ),
            SizedBox(height: 60.0),
            MyButton(
              text: 'Đăng ký',
              onTap: registerAdmin,
              buttonColor: blue,
            ),
            SizedBox(
              height: 50.0,
            ),
            //or continue with
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: grey,
                  ),
                ),
                Text(
                  '      hoặc      ',
                  style: GoogleFonts.roboto(color: grey),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: grey,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            //or login with
            Center(
                child: Text('ĐĂNG NHẬP BẰNG',
                    style: GoogleFonts.roboto(color: grey))),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // LoginWithMore(imagePath: 'assets/icons/facebook.png'),
                // LoginWithMore(imagePath: 'assets/icons/google.png'),
                // LoginWithMore(imagePath: 'assets/icons/apple.png'),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            //text tip
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Đã có tài khoản? ',
                    style: GoogleFonts.roboto(color: grey)),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Đăng nhập ngay!',
                    style: GoogleFonts.roboto(
                        color: blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
