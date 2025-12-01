import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});
  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  String _category = 'Work';
  bool _reminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _titleCtrl, decoration: InputDecoration(hintText: "Enter task title", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            
            const SizedBox(height: 20),
            const Text("Description (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _descCtrl, maxLines: 5, decoration: InputDecoration(hintText: "Add details or notes", alignLabelWithHint: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),

            const SizedBox(height: 20),
            const Text("Deadline", style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${_date.year}-${_date.month}-${_date.day}"), const Icon(Icons.calendar_today)]),
              ),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime(2030));
                if (d != null) setState(() => _date = d);
              },
            ),
            
            const SizedBox(height: 20),
            const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField(
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              value: _category, 
              items: ['Work', 'Health', 'Personal', 'Important'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), 
              onChanged: (v) => setState(() => _category = v!)
            ),
            
            const SizedBox(height: 20),
            SwitchListTile(title: const Text("Set Reminder"), value: _reminder, onChanged: (v) => setState(() => _reminder = v)),
            
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () {
                if (_titleCtrl.text.isEmpty) return;
                final t = Task(id: const Uuid().v4(), title: _titleCtrl.text, description: _descCtrl.text, deadline: _date, category: _category, isReminderOn: _reminder);
                ref.read(taskProvider.notifier).addTask(t);
                Navigator.pop(context);
              },
              child: const Text("SAVE TASK")
            ))
          ],
        ),
      ),
    );
  }
}