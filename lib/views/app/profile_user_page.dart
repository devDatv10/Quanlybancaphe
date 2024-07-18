import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/models/users.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/app/cart_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/home_page.dart';
import 'package:quan_ly_ban_ca_phe/views/app/list_product_page.dart';
import 'package:quan_ly_ban_ca_phe/views/auth/chosse_login_account_page.dart';
import 'package:quan_ly_ban_ca_phe/widgets/notification_dialog.dart';
import 'package:quan_ly_ban_ca_phe/widgets/profile_menu_user.dart';

class ProfileUserPage extends StatefulWidget {
  ProfileUserPage({super.key});

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  int _selectedIndexBottomBar = 3;
  late Stream<Users> userStream;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userStream = FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: currentUser!.email)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Users.fromDocument(doc))
              .toList()
              .first);
    }
  }

  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
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
    var isDrak = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          'TÀI KHOẢN CỦA TÔI',
          style: GoogleFonts.arsenal(color: blue, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
                onPressed: () {}, icon: Icon(isDrak ? Icons.home : Icons.home)),
          )
        ],
      ),
      body: StreamBuilder<Users>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Không có dữ liệu'));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 18.0, top: 10.0, right: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset('assets/images/user.png')),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: white_grey),
                            child: Icon(
                              Icons.camera,
                              size: 20,
                              color: black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.userName,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.verified, color: Colors.blue, size: 18,)
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text(user.email),
                  SizedBox(height: 20.0),
                  // SizedBox(
                  //   width: 160,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           'Chỉnh sửa',
                  //           style: TextStyle(color: white, fontSize: 18),
                  //         ),
                  //         Icon(
                  //           Icons.edit,
                  //           color: white,
                  //           size: 18,
                  //         )
                  //       ],
                  //     ),
                  //     style: ElevatedButton.styleFrom(backgroundColor: blue),
                  //   ),
                  // ),
                  SizedBox(height: 20.0),
                  Divider(),
                  SizedBox(height: 30.0),
                  ProfileMenuUser(
                      title: 'Cài đặt',
                      startIcon: Icons.settings,
                      onPress: () {},
                      textColor: grey),
                  ProfileMenuUser(
                      title: 'Vị trí',
                      startIcon: Icons.pin_drop,
                      onPress: () {},
                      textColor: grey),
                  ProfileMenuUser(
                      title: 'Thời tiết hôm nay',
                      startIcon: Icons.thermostat,
                      onPress: () {},
                      textColor: grey),
                      ProfileMenuUser(
                      title: 'Tài khoản ngân hàng',
                      startIcon: Icons.account_balance,
                      onPress: () {},
                      textColor: grey),
                  ProfileMenuUser(
                      title: 'Quản lý tài khoản',
                      startIcon: Icons.manage_accounts,
                      onPress: () {},
                      textColor: grey),
                  ProfileMenuUser(
                      title: 'Đăng xuất',
                      startIcon: Icons.logout,
                      onPress: () {
                        _showConfirmExit();
                      },
                      endIcon: false,
                      textColor: grey)
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: blue,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndexBottomBar,
          onTap: _selectedBottomBar,
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: Icon(Icons.home)),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListProductPage(),
                    ),
                  );
                },
                child: Icon(Icons.local_cafe),
              ),
              label: 'Đồ uống',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ),
                    );
                  },
                  child: Icon(Icons.shopping_bag)),
              label: 'Giỏ hàng',
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileUserPage(),
                      ),
                    );
                  },
                  child: Icon(Icons.person)),
              label: 'Hồ sơ',
            ),
          ]),
    );
  }
}
