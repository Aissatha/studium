import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  StorageService(this._client);

  final SupabaseClient _client;

  Future<String> uploadUserDoc({
    required String bucket,
    required String path, // ex: "<uid>/applications/<appId>/cv.pdf"
    required File file,
    String? contentType,
    bool upsert = true,
  }) async {
    await _client.storage.from(bucket).upload(
      path,
      file,
      fileOptions: FileOptions(
        upsert: upsert,
        contentType: contentType,
      ),
    );

    // Public URL si bucket public. Si bucket privé, il faudra signedUrl (plus tard).
    final url = _client.storage.from(bucket).getPublicUrl(path);
    return url;
  }
}
