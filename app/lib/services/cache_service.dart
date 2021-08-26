import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';

class CacheService<T> {
  late Box<T> _box;

  Future<bool> initialize() async {
    print('HERE IS IT initializing');
    final document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    _box = await Hive.openBox('box');
    print('HERE IS IT initialized');
    return true;
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
      print('HERE IS IT e $e');
      return AppResponse(error: e.toString());
    }
  }

  Future<AppResponse<bool>> delete(String key) async {
    try {
      await _box.delete(key);

      return AppResponse(data: true);
    } catch (e) {
      return AppResponse(error: e.toString());
    }
  }
}
