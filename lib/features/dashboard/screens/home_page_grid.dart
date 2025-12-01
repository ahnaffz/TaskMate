import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../tasks/providers/task_provider.dart';
import '../../tasks/screens/task_detail_screen.dart';
import '../widgets/sidebar.dart';

class HomePageGrid extends ConsumerWidget {
  const HomePageGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch(taskProvider);
    final workCount = allTasks.where((t) => t.category == 'Work').length;
    final healthCount = allTasks.where((t) => t.category == 'Health').length;
    final personalCount = allTasks.where((t) => t.category == 'Personal').length;
    final importantCount = allTasks.where((t) => t.category == 'Important').length;
    
    final recentTasks = allTasks.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Categories"), centerTitle: true),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.5,
              children: [
                _buildCard("Health", "$healthCount Tasks", const Color(0xFFEBEBFF), Colors.blue),
                _buildCard("Work", "$workCount Tasks", const Color(0xFFE5F9EB), Colors.green),
                _buildCard("Personal", "$personalCount Tasks", const Color(0xFFFDEBF1), Colors.pink),
                _buildCard("Important", "$importantCount Tasks", const Color(0xFFFFF4E5), Colors.orange),
              ],
            ),
            const SizedBox(height: 20),
            const Align(alignment: Alignment.centerLeft, child: Text("Recent Activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: recentTasks.length,
                itemBuilder: (context, index) {
                  final t = recentTasks[index];
                  return ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: t))),
                    leading: Icon(t.isDone ? Icons.check_box : Icons.check_box_outline_blank),
                    title: Text(t.title),
                    subtitle: Align(alignment: Alignment.centerLeft, child: Chip(label: Text(t.category, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.grey[200])),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String count, Color bg, Color accent) {
    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.folder, color: accent),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(title, style: TextStyle(color: Colors.grey[700])),
            ],
          )
        ],
      ),
    );
  }
}