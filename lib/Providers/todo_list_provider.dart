import "package:app/models/base_item.dart";
import "package:flutter/material.dart";

class TodoListProvider extends ChangeNotifier {
  final List<BaseItem<TodoItem>> todoItems = [];
  void addTodoItem(String title, String description) {
    todoItems.add(
      BaseItem<TodoItem>(
        title: title,
        content: description,
        createdAt: DateTime.now(),
        itemData: TodoItem(isCompleted: false),
      ),
    );
    notifyListeners();
  }

  void toggleTodoCompletion(int index) {
    final todo = todoItems[index].asTodoItem;
    if (todo != null) {
      todo.isCompleted = !todo.isCompleted;
      todoItems[index].updatedAt = DateTime.now();
      notifyListeners();
    }
  }

  void deleteTodoItem(int index) {
    todoItems.removeAt(index);
    notifyListeners();
  }
}
