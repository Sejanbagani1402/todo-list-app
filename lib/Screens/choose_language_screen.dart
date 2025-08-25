import 'package:app/widgets/utils/custom_black_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});
  @override
  State<ChooseLanguageScreen> createState() => ChooseLanguageScreenPage();
}

class ChooseLanguageScreenPage extends State<ChooseLanguageScreen> {
  // ignore: strict_top_level_inference
  saveAndNavigateToLogin(Locale locale) async {
    await context.setLocale(locale);
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 90),
          Center(child: Text("choose_language".tr())),
          Spacer(),
          CustomBlackButton(
            text: "english".tr(),
            callback: () => saveAndNavigateToLogin(const Locale("en")),
          ),
          CustomBlackButton(
            text: "hindi".tr(),
            callback: () => saveAndNavigateToLogin(const Locale("hi")),
          ),
        ],
      ),
    );
  }
}
