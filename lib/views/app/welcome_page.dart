import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/widgets/button_get_started.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final String appTitle = 'QUẢN LÝ BÁN CÀ PHÊ';
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background-welcome.jpg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 5),
                Text(
                  appTitle,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.bebasNeue(
                      fontSize: 50.0, color: Colors.white),
                ),
                Spacer(flex: 20),
                Text(
                  '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                Spacer(flex: 2),
                ButtonGetStarted(
                  text: 'Bắt đầu',
                  onTap: () {
                    Get.toNamed('/choose_login_account_page');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
