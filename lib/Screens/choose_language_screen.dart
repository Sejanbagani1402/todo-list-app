import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});
  @override
  State<ChooseLanguageScreen> createState() => ChooseLanguageScreenPage();
}

class ChooseLanguageScreenPage extends State<ChooseLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 90),
          Center(child: Text("choose_language".tr())),
          Spacer(),
          buildLanguageButton(context, "english".tr(), const Locale("en")),
          buildLanguageButton(context, "hindi".tr(), const Locale("hi")),
        ],
      ),
    );
  }

  Widget buildLanguageButton(BuildContext context, String text, Locale locale) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          padding: EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () async {
          await context.setLocale(locale);
          Navigator.pushReplacementNamed(context, "/home");
        },
        child: Text(
          text,
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
