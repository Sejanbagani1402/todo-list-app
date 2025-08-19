import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import '../models/definition.dart';
import "dart:convert";

class DefineScreen extends StatefulWidget {
  const DefineScreen({super.key});
  @override
  State<DefineScreen> createState() => DefineScreenPage();
}

class DefineScreenPage extends State<DefineScreen> {
  final wordController = TextEditingController();
  bool isWordDefined = false;
  String wordDefinition = "";
  bool isLoading = false;
  Future<void> fetchDefinition() async {
    final word = wordController.text.trim().toLowerCase();
    if (word.isEmpty) {
      setState(() {
        wordDefinition = "Please enter a word";
        isWordDefined = false;
      });
      return;
    }
    final url = "https://api.dictionaryapi.dev/api/v2/entries/en/$word";
    setState(() {
      isLoading = true;
      wordDefinition = "";
    });
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final wordData = data[0];
        final meanings = wordData["meanings"] as List;
        final List<Definition> definitions = meanings
            .expand((m) => (m['definitions'] as List))
            .map((d) => Definition.fromJson(d))
            .take(2)
            .toList();
        final allDefinitions = definitions
            .map((def) => def.definition)
            .where((d) => d.isNotEmpty)
            .join("\n\n");
        setState(() {
          wordDefinition = allDefinitions.isNotEmpty
              ? allDefinitions
              : "No definition found";
          isWordDefined = allDefinitions.isNotEmpty;
        });
      } else {
        setState(() {
          wordDefinition = "Error: Word not found on API server.";
          isWordDefined = false;
        });
      }
    } catch (e) {
      setState(() {
        wordDefinition = "An error occurred: $e";
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
                child: const Text(
                  "Define the word",
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
                "Enter your word",
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
          SizedBox(height: 200),
          Text(
            wordDefinition,
            style: TextStyle(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.center,
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
              child: const Text(
                "Define the Word",
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
