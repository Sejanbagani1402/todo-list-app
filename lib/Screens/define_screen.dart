import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:app/Services/dictionary_api_service.dart';

class DefineScreen extends StatefulWidget {
  const DefineScreen({super.key});
  @override
  State<DefineScreen> createState() => DefineScreenPage();
}

class DefineScreenPage extends State<DefineScreen> {
  final wordController = TextEditingController();
  bool isWordDefined = false;
  List<String> meanings = [];
  bool isLoading = false;
  Future<void> fetchDefinition() async {
    final word = wordController.text;
    if (word.isEmpty) return;
    setState(() {
      isLoading = true;
      meanings.clear();
    });
    // final url = "https://api.dictionaryapi.dev/api/v2/entries/en/$word";
    try {
      final response = await DictionaryAPIService.instance.request(
        "/$word",
        DioMethod.get,
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final wordData = data[0];
        if (wordData["meanings"] != null && wordData["meanings"].isNotEmpty) {
          final List defs = wordData["meanings"][0]["definitions"];
          setState(() {
            meanings = defs
                .take(3)
                .map<String>((d) => d["definition"].toString())
                .toList();
            isWordDefined = true;
          });
        } else {
          setState(() {
            meanings = ["error_fetch".tr()];
            isWordDefined = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        meanings = ["${"error_generic".tr()}: $e"];
        isWordDefined = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    wordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 3),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(bottom: 8),
            child: AppBar(
              title: Center(
                child: Text(
                  "define_word".tr(),
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
              automaticallyImplyLeading: false,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          TextFormField(
            controller: wordController,
            decoration: InputDecoration(
              label: Text(
                "enter_word".tr(),
                style: TextStyle(color: Colors.black87),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          if (isLoading) const CircularProgressIndicator(color: Colors.black),
          if (!isLoading && meanings.isNotEmpty)
            Center(
              child: Text(
                "definition_of_word".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: meanings.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "${index + 1}. ${meanings[index]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 24),
            child: ElevatedButton(
              onPressed: fetchDefinition,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                "define_button".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
