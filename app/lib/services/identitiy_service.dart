import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeta_hackathon/services/cache_service.dart';

class IdentityService {
  final CacheService<String> cacheService;

  IdentityService(this.cacheService);

  String getUID() {
    // AppResponse<String?> response = cacheService.getData('userId');
    // if (response.isSuccess())
    //   return response.data!;
    // else
    return FirebaseAuth.instance.currentUser?.displayName ??
        FirebaseAuth.instance.currentUser?.uid ??
        '';
  }

  String? getParentId() {
    // AppResponse<String?> response = cacheService.getData('parentId');
    // return response.data;
    return FirebaseAuth.instance.currentUser?.photoURL ?? '';
  }

  String? getEmail() {
    // AppResponse<String?> response = cacheService.getData('parentId');
    // return response.data;
    return FirebaseAuth.instance.currentUser?.email ?? '';
  }

  Future<void> setParentId(String id) async {
    // AppResponse<bool> response = await cacheService.putData('parentId', id);
    // if (!response.isSuccess()) {
    //   throw Exception(response.error);
    // }
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(id);
  }

  Future<void> setUserId(String id) async {
    // AppResponse<bool> response = await cacheService.putData('userId', id);
    // if (!response.isSuccess()) {
    //   throw Exception(response.error);
    // }
    await FirebaseAuth.instance.currentUser?.updateDisplayName(id);
  }

  void removeParentId() async {
    await FirebaseAuth.instance.currentUser?.updatePhotoURL('');
    // await cacheService.delete('parentId');
  }

  void removeUserId() async {
    await FirebaseAuth.instance.currentUser?.updateDisplayName('');
    // await cacheService.delete('userId');
  }

  Future<void> refreshUser() async {
    await FirebaseAuth.instance.currentUser!.reload();
  }

  String getName() => FirebaseAuth.instance.currentUser!.displayName ?? '';
}
