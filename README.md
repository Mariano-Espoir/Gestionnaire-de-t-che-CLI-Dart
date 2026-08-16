# Application CLI de Gestion de Tâches en Dart

Cette application en ligne de commande (CLI) permet de gérer des tâches de manière structurée et de persister les données localement dans un fichier JSON. Projet développé dans le cadre d'une validation de certification de compétences Dart.

## 🚀 Fonctionnalités
- **Ajouter des tâches** (Standards avec priorités ou Urgentes d'office en priorité haute)
- **Lister toutes les tâches** avec options de tri dynamique (par priorité descendante ou par date limite)
- **Changer le statut** (Marquer comme terminée / En cours)
- **Supprimer une tâche** par son identifiant unique
- **Persistance locale et automatique** dans un fichier JSON local (`tasks.json`)

## 🛠 Exigences Techniques Remplies
- **Programmation Orientée Objet (POO) robuste** : Utilisation d'une classe abstraite `Task` héritée par `StandardTask` et `UrgentTask`.
- **Interface stricte** : Contrat de sérialisation défini via l'interface `Serializable`.
- **Généricité avancée** : Implémentation du pattern Repository à l'aide d'une interface générique `Repository<T>`.
- **Gestion des exceptions** : Classes d'exceptions personnalisées (`TaskNotFoundException`, `InvalidTaskDataException`).
- **Tests unitaires robustes** : Suite de 5 tests unitaires validant l'ensemble de la logique métier.

## 💻 Comment Lancer l'Application

### Prérequis
- Avoir installé le SDK Dart (version >= 3.0.0).

### Instructions
1. Ouvrez votre terminal dans le dossier racine du projet (`todo_cli`).
2. Installez les dépendances du projet :
   ```bash
   dart pub get
   ```
3. Exécutez l'application CLI :
   ```bash
   dart bin/main.dart
   ```

## 🧪 Comment Exécuter les Tests

Pour vérifier la conformité du code et s'assurer du bon fonctionnement des règles métiers, exécutez la commande suivante :
```bash
dart test
```
