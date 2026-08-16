import 'dart:convert';
import 'dart:io';
import '../models/task.dart';
import '../exceptions/task_exceptions.dart';

// Interface générique obligatoire requise par le sujet
abstract class Repository<T> {
  Future<void> save(List<T> items);
  Future<List<T>> load();
}

class JsonTaskRepository implements Repository<Task> {
  final String filePath;

  JsonTaskRepository({this.filePath = 'tasks.json'});

  @override
  Future<void> save(List<Task> items) async {
    try {
      final file = File(filePath);
      final jsonList = items.map((item) => item.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList), flush: true);
    } catch (e) {
      throw TaskException('Impossible de sauvegarder les données : $e');
    }
  }

  @override
  Future<List<Task>> load() async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList.map((json) {
        final id = json['id'] as String;
        final title = json['title'] as String;
        final isCompleted = json['isCompleted'] as bool;
        final dueDateStr = json['dueDate'] as String?;
        final dueDate = dueDateStr != null ? DateTime.parse(dueDateStr) : null;
        final type = json['type'] as String;

        if (type == 'Urgent') {
          return UrgentTask(
              id: id, title: title, isCompleted: isCompleted, dueDate: dueDate);
        } else {
          final priorityStr = json['priority'] as String;
          final priority =
              Priority.values.firstWhere((e) => e.name == priorityStr);
          return StandardTask(
              id: id,
              title: title,
              priority: priority,
              isCompleted: isCompleted,
              dueDate: dueDate);
        }
      }).toList();
    } catch (e) {
      throw TaskException('Erreur lors du chargement des données : $e');
    }
  }
}
