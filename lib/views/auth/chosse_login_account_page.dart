import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';
import 'package:quan_ly_ban_ca_phe/views/auth/auth_admin_page.dart';
import 'package:quan_ly_ban_ca_phe/views/auth/auth_user_page.dart';


class ChooseLoginAccountPage extends StatefulWidget {
  @override
  State<ChooseLoginAccountPage> createState() => _ChooseLoginAccountPageState();
}

class _ChooseLoginAccountPageState extends State<ChooseLoginAccountPage> {
  bool _isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hình nền
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/drawercoffee.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, top: 200, right: 18, bottom: 18.0),
          child: Column(
            children: [
              Text(
                'Đăng nhập với Actor',
                style: GoogleFonts.abrilFatface(
                    color: white,
                    fontSize: 50.0,
                    decoration: TextDecoration.none),
              ),
              SizedBox(height: 250,),
              ElevatedButton(
                onPressed: () {
                  _isLoggedIn = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthUserPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(width: 100,),
                      Text('Đăng nhập khách hàng', style: TextStyle(color: black),),
                    ],
                  )),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _isLoggedIn = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthAdminPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(width: 100,),
                      Text('Đăng nhập Admin', style: TextStyle(color: black)),
                    ],
                  )),
              ),
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back, color: Colors.white, size: 30,)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}