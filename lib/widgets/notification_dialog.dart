import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

void notificationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
  required List<TextButton> actions,
}) {
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
        actions: actions,
      );
    },
  );
}
