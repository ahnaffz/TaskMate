import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme.dart';
import '../../../core/providers/user_provider.dart';
import '../../tasks/providers/task_provider.dart';
import '../../tasks/screens/add_task_screen.dart';
import '../../tasks/screens/task_detail_screen.dart';
import '../../profile/screens/settings_screen.dart';
import '../widgets/sidebar.dart';

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTaskListProvider);
    final filter = ref.watch(filterProvider);
    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(builder: (c) => IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(c).openDrawer())),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())))],
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi, ${userState.name} 👋", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.backgroundLight, borderRadius: BorderRadius.circular(16)),
              child: const Text('"You are capable of great things."', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16)),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Today', 'Work', 'Important', 'Health'].map((f) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: filter == f,
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(color: filter == f ? Colors.white : Colors.black),
                    onSelected: (v) => ref.read(filterProvider.notifier).state = f,
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty ? const Center(child: Text("No tasks in this category")) : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    color: AppTheme.backgroundLight,
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task))),
                      leading: Icon(task.isDone ? Icons.check_circle : Icons.circle_outlined, color: task.isDone ? Colors.green : Colors.grey),
                      title: Text(task.title, style: TextStyle(decoration: task.isDone ? TextDecoration.lineThrough : null)),
                      subtitle: Text("${DateFormat('MMM d').format(task.deadline)} • ${task.category}"),
                      trailing: Chip(label: Text(task.category, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.white),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskScreen())),
      ),
    );
  }
}