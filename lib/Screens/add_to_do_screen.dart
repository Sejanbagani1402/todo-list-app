import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => AddTodoScreenState();
}

class AddTodoScreenState extends State<AddTodoScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
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
                  "Add your Task",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  hintText: "Task Title",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                style: TextStyle(fontSize: 17),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  hintText: "Description (optional)",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                style: TextStyle(fontSize: 16),
                maxLines: 4,
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 24),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, {
                        "title": titleController.text.trim(),
                        "description": descriptionController.text.trim(),
                      });
                    } else {}
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Add Task",
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
        ),
      ),
    );
  }
}
