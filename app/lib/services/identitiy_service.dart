import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeta_hackathon/helpers/app_response.dart';
import 'package:zeta_hackathon/services/cache_service.dart';

class IdentityService {
  final CacheService<String> cacheService;

  IdentityService(this.cacheService);

  String getUID() => FirebaseAuth.instance.currentUser?.uid ?? '';

  String? getParentId() {
    AppResponse<String?> response = cacheService.getData('parentId');
    return response.data;
  }

  Future<void> setParentId(String id) async {
    AppResponse<bool> response = await cacheService.putData('parentId', id);
    if (!response.isSuccess()) throw Exception(response.error);
  }

  void removeParentId() async {
    await cacheService.delete('parentId');
  }

  String getName() => FirebaseAuth.instance.currentUser!.displayName ?? '';
}
