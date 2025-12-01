import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String name;
  final String? imagePath; 

  UserState({required this.name, this.imagePath});
  
  UserState copyWith({String? name, String? imagePath}) {
    return UserState(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(name: "Ahnaf")); 

  void setUserName(String name) {
    state = state.copyWith(name: name);
  }

  void setUserImage(String path) {
    state = state.copyWith(imagePath: path);
  }
  
  // Fungsi Reset untuk Logout
  void logout() {
    state = UserState(name: "Ahnaf"); 
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) => UserNotifier());