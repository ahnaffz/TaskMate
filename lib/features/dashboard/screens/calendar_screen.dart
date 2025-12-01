import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        // REVISI: PAKSA WARNA PUTIH
        title: const Text("Calendar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), 
        backgroundColor: AppTheme.primaryColor, 
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(20), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
            child: TableCalendar(
              firstDay: DateTime.utc(2020), 
              lastDay: DateTime.utc(2030), 
              focusedDay: _focused, 
              selectedDayPredicate: (day) => isSameDay(_selected, day), 
              onDaySelected: (s, f) => setState(() { _selected = s; _focused = f; }),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false, 
                titleCentered: true,
              ),
            )
          )
        ]
      )
    );
  }
}