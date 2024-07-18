import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

class DashboardPage extends StatelessWidget {
  static const String routeName = '/dashboard_page';
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text('Doanh thu', style: GoogleFonts.arsenal(fontSize: 30, color: black, fontWeight: FontWeight.bold),),
            )
          ],
        ),
      ),
    );
  }
}