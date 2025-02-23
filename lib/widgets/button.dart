import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/responsive.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.backgroundColor,
  });

  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding * 1.5,
          vertical: defaultPadding / (Responsive.isDesktop(context) ? 1 : 2),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        onPressed();
      },
      icon: Icon(
        icon,
        size: 20,
        color: Theme.of(context).colorScheme.background,
      ),
      label: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
