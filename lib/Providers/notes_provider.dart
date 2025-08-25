import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/models/base_item.dart';

class NotesProvider extends ChangeNotifier {
  final DatabaseReference _notesRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://sample-6284f-default-rtdb.firebaseio.com/",
  ).ref("notes");

  final List<BaseItem<Notes>> notes = [];

  Future<void> addNote(String title, String content) async {
    final newNote = {
      "title": title,
      "content": content,
      "createdAt": DateTime.now().toIso8601String(),
    };

    await _notesRef.push().set(newNote);
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    await _notesRef.child(id).remove();
    notifyListeners();
  }
}
