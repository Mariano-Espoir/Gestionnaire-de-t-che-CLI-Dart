import 'models/task.dart';
import 'repository/task_repository.dart';
import 'exceptions/task_exceptions.dart';

class TaskManager {
  final Repository<Task> _repository;
  List<Task> _tasks = [];

  TaskManager(this._repository);

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> init() async {
    _tasks = await _repository.load();
  }

  void addTask(Task task) {
    if (task.title.trim().isEmpty) {
      throw InvalidTaskDataException(
          'Le titre de la tâche ne peut pas être vide.');
    }
    _tasks.add(task);
  }

  void toggleTaskCompletion(String id) {
    final task = _tasks.firstWhere(
      (t) => t.id == id,
      orElse: () => throw TaskNotFoundException(id),
    );
    task.isCompleted = !task.isCompleted;
  }

  void deleteTask(String id) {
    final initialLength = _tasks.length;
    _tasks.removeWhere((t) => t.id == id);
    if (_tasks.length == initialLength) {
      throw TaskNotFoundException(id);
    }
  }

  List<Task> getTasksSortedByPriority() {
    final sorted = List<Task>.from(_tasks);
    sorted.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    return sorted;
  }

  List<Task> getTasksSortedByDate() {
    final sorted = List<Task>.from(_tasks);
    sorted.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return sorted;
  }

  Future<void> saveChanges() async {
    await _repository.save(_tasks);
  }
}
