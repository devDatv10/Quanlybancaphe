import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/user/login_user_with_email_and_password_page.dart';
import 'package:quan_ly_ban_ca_phe/widgets/my_button.dart';
import 'package:quan_ly_ban_ca_phe/widgets/my_text_form_field.dart';
import 'package:quan_ly_ban_ca_phe/widgets/text_form_field_email.dart';
import 'package:quan_ly_ban_ca_phe/widgets/text_form_field_password.dart';

class RegisterUserWithEmailAndPasswordPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterUserWithEmailAndPasswordPage({super.key, required this.onTap});

  @override
  State<RegisterUserWithEmailAndPasswordPage> createState() =>
      _RegisterUserWithEmailAndPasswordPageState();
}

class _RegisterUserWithEmailAndPasswordPageState
    extends State<RegisterUserWithEmailAndPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isObsecureName = false;
  bool isObsecurePassword = false;
  bool isObsecureConfirmPassword = false;

  Future registerUser() async {
    String email = _emailController.text.trim();
    int phoneNumber = int.tryParse(_phoneNumberController.text.trim()) ?? 0;
    String address = _addressController.text.trim();
    String userName = _userNameController.text.trim();
    String password = _passWordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty ||
        phoneNumber == 0 ||
        address.isEmpty ||
        userName.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showNotification(context,
          "Đăng ký không thành công, không được điền thiếu các thông tin");
      return;
    }

    if (!passWordConfirmed()) {
      showNotification(context, "Mật khẩu không khớp, vui lòng thử lại");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        addUserDetail(
            email, phoneNumber, address, userName, password, confirmPassword);

        showNotification(
            context, "Đăng ký thành công với email: $email đăng nhập ngay");
        Get.offAll(LoginUserWithEmailAndPasswordPage(
          onTap: () {},
        ));
      }
      showNotification(context, "Đăng ký thành công với email: $email");
    } on FirebaseAuthException catch (e) {
      print("Lỗi xác thực: ${e.message}");
    }
  }

  void dispose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _userNameController.dispose();
    _passWordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future addUserDetail(String email, int phoneNumber, String address,
      String userName, String passWord, String confirmPassword) async {
    await FirebaseFirestore.instance.collection('Users').add({
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'userName': userName,
      'passWord': passWord,
      'confirmPasword': confirmPassword
    });
  }

  bool passWordConfirmed() {
    if (_passWordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
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
        padding: const EdgeInsets.only(left: 18.0, top: 100.0, right: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //title email
            Center(
              child: Text(
                'Màn hình đăng ký',
                style: GoogleFonts.arsenal(
                    fontSize: 30.0, fontWeight: FontWeight.bold, color: blue),
              ),
            ),
            SizedBox(
              height: 35.0,
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
            //form phone number
            MyTextFormField(
              hintText: 'Số điện thoại',
              prefixIconData: Icons.phone,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _addressController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: grey,
                  )),
              controller: _phoneNumberController,
              iconColor: grey,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),

            SizedBox(
              height: 20.0,
            ),
            //form address
            MyTextFormField(
              hintText: 'Địa chỉ',
              prefixIconData: Icons.location_on,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _addressController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: grey,
                  )),
              controller: _addressController,
              iconColor: grey,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form name
            MyTextFormField(
              hintText: 'Tên hiển thị',
              prefixIconData: Icons.person,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _userNameController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: grey,
                  )),
              controller: _userNameController,
              iconColor: grey,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form password
            TextFormFieldPassword(
              hintText: 'Mật khẩu',
              prefixIconData: Icons.key,
              suffixIcon: IconButton(
                icon: Icon(
                  isObsecurePassword ? Icons.visibility : Icons.visibility_off,
                  color: grey,
                ),
                onPressed: () {
                  setState(() {
                    isObsecurePassword = !isObsecurePassword;
                  });
                },
              ),
              controller: _passWordController,
              iconColor: grey,
              obscureText: !isObsecurePassword,
            ),
            SizedBox(
              height: 20.0,
            ),
            //form confirm password
            MyTextFormField(
              hintText: 'Xác nhận mật khẩu',
              prefixIconData: Icons.key,
              suffixIcon: IconButton(
                icon: Icon(
                  isObsecureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: grey,
                ),
                onPressed: () {
                  setState(() {
                    isObsecureConfirmPassword = !isObsecureConfirmPassword;
                  });
                },
              ),
              controller: _confirmPasswordController,
              iconColor: grey,
              obscureText: !isObsecureConfirmPassword,
            ),
            SizedBox(
              height: 50.0,
            ),
            //button signinup
            MyButton(
              text: 'Đăng ký',
              onTap: registerUser,
              buttonColor: green,
            ),
            SizedBox(
              height: 25.0,
            ),
            //or continue with
            Row(
              children: [
                // Expanded(
                //   child: Divider(
                //     thickness: 1,
                //     color: grey,
                //   ),
                // ),
                // Text(
                //   '      hoặc      ',
                //   style: GoogleFonts.roboto(color: black),
                // ),
                // Expanded(
                //   child: Divider(
                //     thickness: 1,
                //     color: grey,
                //   ),
                // )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            //or login with
            // Center(
            //     child: Text('ĐĂNG NHẬP BẰNG',
            //         style: GoogleFonts.roboto(color: black))),
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
              height: 20,
            ),
            //text tip
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Đã có tài khoản? ',
                    style: GoogleFonts.roboto(color: black)),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Đăng nhập',
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
