import 'package:cyber_map/core/config/injectable/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@module
abstract class InjectionClientModule {
  @lazySingleton
  http.Client get httpClient => http.Client();
}

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: false,
  asExtension: false,
  generateForDir: ['lib'],
)
void configureDependencies({required String environment}) {
  $initGetIt(getIt, environment: environment);
}
