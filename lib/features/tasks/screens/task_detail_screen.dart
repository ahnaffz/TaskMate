import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends ConsumerWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Detail"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(label: Text(task.category, style: const TextStyle(color: Colors.purple)), backgroundColor: Colors.purple.withOpacity(0.1)),
                  const SizedBox(height: 10),
                  Text(task.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  const Text("Description", style: TextStyle(color: Colors.grey)),
                  Text(task.description.isEmpty ? "No description provided." : task.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Row(children: [const Icon(Icons.calendar_today, size: 16), const SizedBox(width: 5), Text("Deadline: ${DateFormat.yMMMd().format(task.deadline)}")])
                ],
              ),
            ),
            const Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D344B)),
              onPressed: () { ref.read(taskProvider.notifier).toggleStatus(task.id); Navigator.pop(context); }, 
              child: Text(task.isDone ? "MARK AS UNDONE" : "MARK AS DONE")
            )),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: OutlinedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditTaskScreen(task: task))),
              child: const Text("EDIT TASK")
            )),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
              onPressed: () { ref.read(taskProvider.notifier).deleteTask(task.id); Navigator.pop(context); },
              child: const Text("DELETE TASK")
            )),
          ],
        ),
      ),
    );
  }
}