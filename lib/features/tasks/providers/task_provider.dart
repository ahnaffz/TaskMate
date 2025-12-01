import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';

final List<Task> _initialTasks = [
  Task(id: '1', title: 'Complete Project Proposal', description: 'Finalize requirements', deadline: DateTime.now(), category: 'Work', isDone: false),
  Task(id: '2', title: 'Morning Workout', description: 'Gym session', deadline: DateTime.now(), category: 'Health', isDone: true),
];

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super(_initialTasks);

  void addTask(Task t) {
    state = [t, ...state];
  }
  
  void updateTask(Task u) => state = [for (final t in state) if (t.id == u.id) u else t];
  
  void toggleStatus(String id) {
    state = [for (final t in state) 
      if (t.id == id) Task(id: t.id, title: t.title, description: t.description, deadline: t.deadline, category: t.category, isDone: !t.isDone, isReminderOn: t.isReminderOn) 
      else t];
  }
  
  void deleteTask(String id) => state = state.where((t) => t.id != id).toList();
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
final filterProvider = StateProvider<String>((ref) => 'All');

final filteredTaskListProvider = Provider<List<Task>>((ref) {
  final filter = ref.watch(filterProvider);
  final tasks = ref.watch(taskProvider);
  
  if (filter == 'Today') {
    final now = DateTime.now();
    return tasks.where((t) => t.deadline.day == now.day && t.deadline.month == now.month).toList();
  } else if (filter == 'Important') {
     return tasks.where((t) => t.category == 'Important').toList();
  } else if (filter != 'All') {
    return tasks.where((t) => t.category == filter).toList();
  }
  return tasks;
});