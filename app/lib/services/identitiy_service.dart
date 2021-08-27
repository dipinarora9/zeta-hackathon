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
      return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  String? getParentId() {
    AppResponse<String?> response = cacheService.getData('parentId');
    return response.data;
  }

  String? getAccountId() {
    AppResponse<String?> response = cacheService.getData('accountId');
    return response.data;
  }

  String? getPoolAccountId() {
    AppResponse<String?> response = cacheService.getData('poolAccountId');
    return response.data;
  }

  String? getAccountHolderId() {
    AppResponse<String?> response = cacheService.getData('accountHolderId');
    return response.data;
  }

  String? getResourceId() {
    AppResponse<String?> response = cacheService.getData('resourceId');
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

  Future<void> setAccountId(String id) async {
    AppResponse<bool> response = await cacheService.putData('accountId', id);
    if (!response.isSuccess()) {
      throw Exception(response.error);
    }
  }

  Future<void> setAccountHolderId(String id) async {
    AppResponse<bool> response =
        await cacheService.putData('accountHolderId', id);
    if (!response.isSuccess()) {
      throw Exception(response.error);
    }
  }

  Future<void> setPoolAccountId(String id) async {
    AppResponse<bool> response =
        await cacheService.putData('poolAccountId', id);
    if (!response.isSuccess()) {
      throw Exception(response.error);
    }
  }

  Future<void> setResourceId(String id) async {
    AppResponse<bool> response = await cacheService.putData('resourceId', id);
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
