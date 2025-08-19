import "package:app/models/todo_item.dart";
import "package:flutter/material.dart";

class TodoListProvider extends ChangeNotifier {
  final List<TodoItem> todoItems = [];
  void addTodoItem(String title, String description) {
    todoItems.add(
      TodoItem(title: title, description: description, isCompleted: false),
    );
    notifyListeners();
  }

  void toggleTodoCompletion(int index) {
    todoItems[index].isCompleted = !todoItems[index].isCompleted;
    notifyListeners();
  }

  void deleteTodoItem(int index) {
    todoItems.removeAt(index);
    notifyListeners();
  }
}
