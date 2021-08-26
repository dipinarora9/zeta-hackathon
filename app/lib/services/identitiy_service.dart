import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/services/cache_service.dart';

class IdentityService {
  final CacheService<String> cacheService;

  IdentityService(this.cacheService);

  String getUID() {
    AppResponse<String?> response = cacheService.getData('userId');
    if (response.isSuccess())
      return response.data!;
    else
      return FirebaseAuth.instance.currentUser?.displayName ??
          FirebaseAuth.instance.currentUser?.uid ??
          '';
  }

  String? getParentId() {
    AppResponse<String?> response = cacheService.getData('parentId');
    print('HERE IS IT dipin ${response.data}');
    return response.data;
  }

  String? getEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? '';
  }

  Future<void> setParentId(String id) async {
    AppResponse<bool> response = await cacheService.putData('parentId', id);
    if (!response.isSuccess()) {
      print('HERE IS IT ${response.error}');
      throw Exception(response.error);
    }
  }

  Future<void> setUserId(String id) async {
    AppResponse<bool> response = await cacheService.putData('userId', id);
    if (!response.isSuccess()) {
      throw Exception(response.error);
    }
  }

  void removeParentId() async {
    await cacheService.delete('parentId');
  }

  void removeUserId() async {
    await cacheService.delete('userId');
  }

  Future<void> refreshUser() async {
    await FirebaseAuth.instance.currentUser!.reload();
  }

  String getName() => FirebaseAuth.instance.currentUser!.displayName ?? '';
}
