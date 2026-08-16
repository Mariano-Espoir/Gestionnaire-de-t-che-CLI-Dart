enum Priority { low, medium, high }

// Interface obligatoire demandée
abstract class Serializable {
  Map<String, dynamic> toJson();
}

// Classe abstraite de base
abstract class Task implements Serializable {
  final String id;
  String title;
  Priority priority;
  bool isCompleted;
  DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.isCompleted = false,
    this.dueDate,
  });

  String get taskType;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority.name,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'type': taskType,
    };
  }
}

// Spécialisation 1 : StandardTask
class StandardTask extends Task {
  StandardTask({
    required super.id,
    required super.title,
    required super.priority,
    super.isCompleted,
    super.dueDate,
  });

  @override
  String get taskType => 'Standard';
}

// Spécialisation 2 : UrgentTask (Héritage obligatoire requis par le sujet)
class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    super.isCompleted,
    super.dueDate,
  }) : super(priority: Priority.high);

  @override
  String get taskType => 'Urgent';
}
