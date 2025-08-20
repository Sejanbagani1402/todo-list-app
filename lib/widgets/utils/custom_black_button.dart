import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomBlackButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  const CustomBlackButton({
    super.key,
    required this.text,
    required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 24),
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          padding: EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          text.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
