class Definition {
  final String definition;
  Definition({required this.definition});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(definition: json['definition'] as String);
  }
}
