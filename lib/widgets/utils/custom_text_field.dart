import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final maxLines;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.maxLines,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintText: text.tr(),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      style: TextStyle(fontSize: 16),
      maxLines: maxLines,
    );
  }
}
