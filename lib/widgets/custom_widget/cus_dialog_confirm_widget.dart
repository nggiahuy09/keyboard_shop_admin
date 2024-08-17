import 'package:flutter/material.dart';

class CusConfirmationDialog extends StatelessWidget {
  const CusConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.acceptOption,
    this.denyOption,
  });

  final String title;
  final String content;
  final TextButton acceptOption;
  final TextButton? denyOption;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      actions: [
        if (denyOption != null) denyOption!,
        acceptOption,
      ],
    );
  }
}
