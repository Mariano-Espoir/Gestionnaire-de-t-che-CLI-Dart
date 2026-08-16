import 'dart:io';
import 'package:todo_cli/models/task.dart';
import 'package:todo_cli/repository/task_repository.dart';
import 'package:todo_cli/task_manager.dart';
import 'package:todo_cli/exceptions/task_exceptions.dart';

void main() async {
  final repository = JsonTaskRepository();
  final manager = TaskManager(repository);

  try {
    await manager.init();
  } catch (e) {
    print('⚠️ Erreur d\'initialisation : $e');
  }

  print('========================================');
  print('    🚀 GESTIONNAIRE DE TÂCHES CLI      ');
  print('========================================');

  while (true) {
    print('\nMenu principal :');
    print('1. Ajouter une tâche standard');
    print('2. Ajouter une tâche urgente (Haute priorité)');
    print('3. Lister toutes les tâches (Tri par défaut)');
    print('4. Lister et trier par priorité');
    print('5. Lister et trier par date limite');
    print('6. Marquer une tâche comme terminée/en cours');
    print('7. Supprimer une tâche');
    print('8. Quitter');
    stdout.write('Choisissez une option (1-8) : ');

    final choice = stdin.readLineSync()?.trim();

    try {
      switch (choice) {
        case '1':
          stdout.write('Titre de la tâche : ');
          final title = stdin.readLineSync()?.trim() ?? '';

          print('Priorité (1: Low, 2: Medium, 3: High) : ');
          final pChoice = stdin.readLineSync()?.trim();
          var priority = Priority.medium;
          if (pChoice == '1') priority = Priority.low;
          if (pChoice == '3') priority = Priority.high;

          stdout.write('Date limite (AAAA-MM-JJ, optionnel) : ');
          final dateStr = stdin.readLineSync()?.trim();
          DateTime? dueDate = dateStr != null && dateStr.isNotEmpty
              ? DateTime.parse(dateStr)
              : null;

          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final task = StandardTask(
              id: id, title: title, priority: priority, dueDate: dueDate);
          manager.addTask(task);
          await manager.saveChanges();
          print('✅ Tâche standard ajoutée avec succès ! ID: $id');
          break;

        case '2':
          stdout.write('Titre de la tâche urgente : ');
          final title = stdin.readLineSync()?.trim() ?? '';

          stdout.write('Date limite (AAAA-MM-JJ, optionnel) : ');
          final dateStr = stdin.readLineSync()?.trim();
          DateTime? dueDate = dateStr != null && dateStr.isNotEmpty
              ? DateTime.parse(dateStr)
              : null;

          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final task = UrgentTask(id: id, title: title, dueDate: dueDate);
          manager.addTask(task);
          await manager.saveChanges();
          print('🚨 Tâche urgente ajoutée avec succès ! ID: $id');
          break;

        case '3':
          _displayTasks(manager.tasks);
          break;

        case '4':
          _displayTasks(manager.getTasksSortedByPriority());
          break;

        case '5':
          _displayTasks(manager.getTasksSortedByDate());
          break;

        case '6':
          stdout.write('Entrez l\'ID de la tâche à modifier : ');
          final id = stdin.readLineSync()?.trim() ?? '';
          manager.toggleTaskCompletion(id);
          await manager.saveChanges();
          print('🔄 Statut de la tâche mis à jour !');
          break;

        case '7':
          stdout.write('Entrez l\'ID de la tâche à supprimer : ');
          final id = stdin.readLineSync()?.trim() ?? '';
          manager.deleteTask(id);
          await manager.saveChanges();
          print('❌ Tâche supprimée définitivement !');
          break;

        case '8':
          print('👋 Au revoir ! Vos modifications sont sauvegardées.');
          exit(0);

        default:
          print('⚠️ Option invalide. Entrez un chiffre entre 1 et 8.');
      }
    } on TaskException catch (e) {
      print('❌ $e');
    } catch (e) {
      print('❌ Erreur inattendue : $e');
    }
  }
}

void _displayTasks(List<Task> tasks) {
  if (tasks.isEmpty) {
    print('\n[Aucune tâche enregistrée]');
    return;
  }
  print('\n--- LISTE DES TÂCHES ---');
  for (var task in tasks) {
    final status = task.isCompleted ? '[✅ Terminée]' : '[⏳ En cours]';
    final type = task.taskType == 'Urgent' ? '🚨 URGENT' : '📋 Standard';
    final date = task.dueDate != null
        ? '📅 Limite: ${task.dueDate!.toIso8601String().split('T')[0]}'
        : '📅 Pas de limite';
    print(
        'ID: ${task.id} | $status | Prio: ${task.priority.name.toUpperCase()} | Type: $type | Titre: ${task.title} | $date');
  }
  print('------------------------');
}
