class Todo {
  int? id;
  final String? title;
  final String? note;
  final String? alarmId;
  final bool? isCompleted;
  final bool? isArchived;
  final DateTime? dateCreated;
  Todo({
    this.alarmId,
    this.isArchived,
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.dateCreated,
  });
  Map<String, Object?> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'note': note,
      'alarmId': alarmId,
      'isArchived': isArchived! ? 0 : 1,
      'isCompleted': isCompleted! ? 0 : 1,
      'dateCreated': dateCreated!.toIso8601String(),
    };
  }

  factory Todo.fromMap(Map<String, Object?> map) {
    return Todo(
      id: map['id'] as int,
      title: map['title'] as String,
      alarmId: map['alarmId'] as String,
      note: map['note'] == null ? null : map['note'] as String,
      isCompleted: map['isCompleted'] == 0,
      isArchived: map['isArchived'] == 0,
      dateCreated: DateTime.parse(map['dateCreated'] as String),
    );
  }
}
