import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../core/theme.dart';
import '../../../core/providers/user_provider.dart';
import '../screens/home_dashboard.dart';
import '../screens/home_page_grid.dart';
import '../screens/calendar_screen.dart';
import '../../profile/screens/settings_screen.dart';

class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    
    // REVISI: DEFAULT AVATAR JADI ANONYM (ICON)
    ImageProvider? avatarImage;
    Widget? childWidget;

    if (userState.imagePath != null && File(userState.imagePath!).existsSync()) {
      avatarImage = FileImage(File(userState.imagePath!));
    } else {
      // Tidak pakai gambar, tapi pakai Icon
      avatarImage = null;
      childWidget = const Icon(Icons.person, size: 50, color: Colors.grey);
    }

    return Drawer(
      backgroundColor: AppTheme.primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryColor),
            accountName: Text(userState.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            accountEmail: const Text("Online", style: TextStyle(color: Colors.green)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: avatarImage,
              child: childWidget,
            ),
          ),
          _buildItem(context, Icons.dashboard, "Dashboard (List)", const HomeDashboard()),
          _buildItem(context, Icons.grid_view, "Home Page (Grid)", const HomePageGrid()),
          _buildItem(context, Icons.calendar_today, "Calendar", const CalendarScreen()),
          _buildItem(context, Icons.settings, "Settings", const SettingsScreen()),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context); // Tutup drawer
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}