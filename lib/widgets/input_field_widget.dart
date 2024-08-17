import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.title,
    required this.textEditingController,
    required this.scaffoldColor,
    required this.borderSideColor,
    required this.validate,
    this.inputFormatter,
  });

  final String title;
  final TextEditingController textEditingController;
  final Color scaffoldColor, borderSideColor;
  final String? Function(String? value) validate;
  final List<TextInputFormatter>? inputFormatter;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final InputDecoration inputDecoration;

  @override
  void initState() {
    inputDecoration = InputDecoration(
      filled: true,
      fillColor: widget.scaffoldColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: widget.borderSideColor.withOpacity(0.5),
          width: 0.75,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          key: const ValueKey('title'),
          controller: widget.textEditingController,
          decoration: inputDecoration,
          inputFormatters: widget.inputFormatter,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          validator: (value) => widget.validate(value),
        ),
      ],
    );
  }
}