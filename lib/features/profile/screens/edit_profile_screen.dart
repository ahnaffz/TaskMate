import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme.dart';
import '../../../core/providers/user_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(userProvider);
    _nameController = TextEditingController(text: currentUser.name);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(userProvider.notifier).setUserImage(image.path);
    }
  }

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
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), 
        backgroundColor: AppTheme.primaryColor, 
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(20), 
        child: Column(
          children: [
            CircleAvatar(
              radius: 50, 
              backgroundColor: Colors.grey[200],
              backgroundImage: avatarImage,
              child: childWidget,
            ),
            
            TextButton(
              onPressed: _pickImage, 
              child: const Text("Change Photo")
            ),
            const SizedBox(height: 20),
            
            const Align(alignment: Alignment.centerLeft, child: Text("Full Name", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController, 
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
              )
            ),
            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {
                  if(_nameController.text.isNotEmpty) {
                    ref.read(userProvider.notifier).setUserName(_nameController.text);
                    Navigator.pop(context); 
                  }
                }, 
                child: const Text("Save Changes")
              )
            )
          ]
        )
      ),
    );
  }
}