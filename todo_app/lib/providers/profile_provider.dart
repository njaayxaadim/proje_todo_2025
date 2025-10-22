import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, String?>((ref) => ProfileNotifier());

class ProfileNotifier extends StateNotifier<String?> {
  ProfileNotifier() : super(null) {
    _loadPhoto();
  }

  Future<void> _loadPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('profile_photo');
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_photo', pickedFile.path);
      state = pickedFile.path;
    }
  }
}
