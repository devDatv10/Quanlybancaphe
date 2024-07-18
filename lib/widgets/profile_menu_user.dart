import 'package:flutter/material.dart';

import '../themes/theme.dart';

class ProfileMenuUser extends StatelessWidget {
  const ProfileMenuUser({
    super.key,
    required this.title,
    required this.startIcon,
    required this.onPress,
    this.endIcon = true,
    required this.textColor,
  });

  final String title;
  final IconData startIcon;
  final Function() onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: grey.withOpacity(0.1),
        ),
        child: Icon(
          startIcon,
          color: blue,
        ),
      ),
      title: Text(title),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: grey.withOpacity(0.1),
              ),
              child: Icon(Icons.arrow_forward, color: grey),
            )
          : null,
    );
  }
}