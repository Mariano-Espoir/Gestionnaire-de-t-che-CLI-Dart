class TaskException implements Exception {
  final String message;
  TaskException(this.message);
  @override
  String toString() => 'Erreur Application: $message';
}

class TaskNotFoundException extends TaskException {
  TaskNotFoundException(String id)
      : super('Tâche avec l\'ID "$id" introuvable.');
}

class InvalidTaskDataException extends TaskException {
  InvalidTaskDataException(String message)
      : super('Données invalides : $message');
}
