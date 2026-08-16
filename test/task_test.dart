import 'package:test/test.dart';
import 'package:todo_cli/models/task.dart';
import 'package:todo_cli/task_manager.dart';
import 'package:todo_cli/repository/task_repository.dart';
import 'package:todo_cli/exceptions/task_exceptions.dart';

class MockTaskRepository implements Repository<Task> {
  List<Task> storage = [];
  @override
  Future<List<Task>> load() async => storage;
  @override
  Future<void> save(List<Task> items) async => storage = List.from(items);
}

void main() {
  group('Tests Unitaires de Gestion de Tâches', () {
    late TaskManager manager;
    late MockTaskRepository mockRepo;

    setUp(() async {
      mockRepo = MockTaskRepository();
      manager = TaskManager(mockRepo);
      await manager.init();
    });

    test('1. Ajout réussi d\'une tâche et vérification du type', () {
      final task = StandardTask(
          id: '1', title: 'Acheter du lait', priority: Priority.medium);
      manager.addTask(task);
      expect(manager.tasks.length, 1);
      expect(manager.tasks.first.title, 'Acheter du lait');
    });

    test('2. Levée d\'exception si le titre est vide', () {
      final task = StandardTask(id: '2', title: '   ', priority: Priority.low);
      expect(() => manager.addTask(task),
          throwsA(isA<InvalidTaskDataException>()));
    });

    test('3. Inversion correcte du statut de complétion', () {
      final task = StandardTask(
          id: '3', title: 'Faire du sport', priority: Priority.low);
      manager.addTask(task);
      manager.toggleTaskCompletion('3');
      expect(manager.tasks.first.isCompleted, true);
    });

    test(
        '4. Levée d\'exception lors de la modification d\'une tâche inexistante',
        () {
      expect(() => manager.toggleTaskCompletion('999'),
          throwsA(isA<TaskNotFoundException>()));
    });

    test('5. Tri efficace par ordre de priorité descendante', () {
      manager.addTask(
          StandardTask(id: 'low', title: 'Basse', priority: Priority.low));
      manager.addTask(UrgentTask(
          id: 'urgent', title: 'Urgentissime')); // Priorité haute implicite
      manager.addTask(
          StandardTask(id: 'med', title: 'Moyenne', priority: Priority.medium));

      final sorted = manager.getTasksSortedByPriority();
      expect(sorted[0].priority, Priority.high);
      expect(sorted[1].priority, Priority.medium);
      expect(sorted[2].priority, Priority.low);
    });
  });
}
