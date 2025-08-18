import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
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
      return;
    }
    final url = "https://wordsapiv1.p.rapidapi.com/words/$word/definitions";
    setState(() {
      isLoading = true;
      wordDefinition = "";
    });
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "X-RapidAPI-Key":
              "2f66d7d4a6msh51950da60920dc9p1305c6jsnec731631ac52",
          "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final definitions = data['definitions'];

        if (definitions != null && definitions.isNotEmpty) {
          setState(() {
            wordDefinition = definitions[0]['definition'];
            isWordDefined = true;
          });
        } else {
          setState(() {
            wordDefinition = "No definitions found.";
            isWordDefined = false;
          });
        }
      } else {
        setState(() {
          wordDefinition = "Error: Unable to fetch definition.";
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
