class Task {
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final String category;
  final bool isDone;
  final bool isReminderOn;

  Task({
    required this.id, 
    required this.title, 
    required this.description, 
    required this.deadline, 
    required this.category, 
    this.isDone = false, 
    this.isReminderOn = false
  });
}