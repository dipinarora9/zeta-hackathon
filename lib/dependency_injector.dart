import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Controllers
  ///
  // sl.registerFactory<HomepageController>(() => HomepageController(
  //     sl<HttpService>(),
  //     sl<AuthenticationService>(),
  //     sl<CartService>(),
  //     sl<UserService>(),
  //     sl<CacheService<int>>()));

  ///Services
  ///
  // sl.registerLazySingleton<HttpService>(() => HttpService());
}
