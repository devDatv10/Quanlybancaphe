import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonGetStarted extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const ButtonGetStarted({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          color: Colors.grey[300]
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 25)),
            const SizedBox(width: 10.0,),
            const Icon(Icons.arrow_forward, color: Colors.black,)
          ],
        ),
      ),
    );
  }
}