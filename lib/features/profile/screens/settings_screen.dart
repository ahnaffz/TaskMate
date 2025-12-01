import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../core/providers/user_provider.dart';
import 'edit_profile_screen.dart';
import '../../auth/screens/login_screen.dart'; // Import Login
import 'dart:io';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    
    ImageProvider? avatarImage;
    Widget? childWidget;
    if (userState.imagePath != null && File(userState.imagePath!).existsSync()) {
      avatarImage = FileImage(File(userState.imagePath!));
    } else {
      childWidget = const Icon(Icons.person, size: 50, color: Colors.grey);
    }

    return Scaffold(
      appBar: AppBar(
        // REVISI: PAKSA WARNA PUTIH
        title: const Text("Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), 
        backgroundColor: AppTheme.primaryColor, 
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 40, 
            backgroundColor: Colors.grey[200],
            backgroundImage: avatarImage,
            child: childWidget,
          ),
          Center(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(userState.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
          Center(child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())), child: const Text("Edit Profile"))),
          const Divider(),
          
          SwitchListTile(
            title: const Text("Notifications"), 
            value: _notificationsEnabled, 
            onChanged: (v) {
              setState(() => _notificationsEnabled = v);
              if (v) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("TaskMate: Notifikasi aktif! Anda akan diingatkan 30 menit sebelum deadline."),
                    backgroundColor: AppTheme.primaryColor,
                  )
                );
              }
            }
          ),
          ListTile(title: const Text("Theme"), trailing: const Text("Light >"), onTap: () {}),
          const SizedBox(height: 40),
          
          // REVISI: TOMBOL LOGOUT BERFUNGSI
          Center(
            child: TextButton(
              onPressed: () {
                // Reset state user (opsional)
                ref.read(userProvider.notifier).logout();
                // Navigasi paksa ke halaman login dan hapus riwayat
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (_) => const LoginScreen()), 
                  (route) => false
                );
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red, fontSize: 16))
            )
          )
        ],
      ),
    );
  }
}