import 'package:hive/hive.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';

class CacheService<T> {
  late final Box<T> _box;

  initialize() async {
    _box = await Hive.openBox('box');
  }

  AppResponse<T?> getData(String key) {
    try {
      T? result = _box.get(key);
      return AppResponse(data: result);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> putData(String key, T value) async {
    try {
      await _box.put(key, value);
      return AppResponse(data: true);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}
