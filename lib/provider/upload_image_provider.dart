import 'dart:typed_data';
import 'package:dio_project/models/firebace_user_model.dart';
import 'package:dio_project/repository/auth_repository.dart';
import 'package:dio_project/repository/supabace_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadController extends AutoDisposeAsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    return null;
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final Uint8List bytes = await image.readAsBytes();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = 'uploads/$fileName';

      final repository = ref.read(supabaseRepositoryProvider);
      return await repository.uploadImage(bytes, path);
    });
  }
}

// Provider definition
final imageUploadControllerProvider =
    AutoDisposeAsyncNotifierProvider<ImageUploadController, String?>(
      ImageUploadController.new,
    );

final userStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.userStateChanges();
});
