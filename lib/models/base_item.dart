class BaseItem<T> {
  final String title;
  final String content;
  final DateTime createdAt;
  DateTime? updatedAt;
  final T itemData;

  BaseItem({
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.itemData,
  });
  bool get isTodoItem => itemData is TodoItem;
  bool get isNote => itemData is Notes;

  TodoItem? get asTodoItem => isTodoItem ? itemData as TodoItem : null;
  Notes? get asNote => isNote ? itemData as Notes : null;
}

class TodoItem {
  bool isCompleted;
  TodoItem({required this.isCompleted});
}

class Notes {
  const Notes();
}
