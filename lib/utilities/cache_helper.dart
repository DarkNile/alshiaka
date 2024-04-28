import 'package:get_storage/get_storage.dart';

class CacheHelper {
  static final _box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  static dynamic read(String key) {
    return _box.read(key);
  }

  static Future<void> remove(String key) async {
    await _box.remove(key);
  }

  static Future<void> clear() async {
    await _box.erase();
  }
}
