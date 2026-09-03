import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider.autoDispose<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

class SupabaseRepository {
  final SupabaseClient supabase;

  SupabaseRepository({required this.supabase});

  Future<String> uploadImage(Uint8List bytes, String path) async {
    await supabase.storage.from('image upload').uploadBinary(path, bytes);

    return supabase.storage.from('image upload').getPublicUrl(path);
  }
}

final supabaseRepositoryProvider = Provider.autoDispose<SupabaseRepository>((
  ref,
) {
  final supabase = ref.watch(supabaseProvider);

  return SupabaseRepository(supabase: supabase);
});
