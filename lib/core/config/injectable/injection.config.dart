// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cyber_map/core/config/injectable/injection.dart' as _i16;
import 'package:cyber_map/core/data/repositories/overpass_osm_repository.dart'
    as _i10;
import 'package:cyber_map/core/data/repositories/secure_storage_key_value_repository.dart'
    as _i12;
import 'package:cyber_map/core/data/repositories/sqlite_osm_repository.dart'
    as _i14;
import 'package:cyber_map/core/domain/cubits/emoji_tag_map/emoji_tag_map_cubit.dart'
    as _i5;
import 'package:cyber_map/core/domain/cubits/map_position/map_position_cubit.dart'
    as _i3;
import 'package:cyber_map/core/domain/cubits/navigation/navigation_cubit.dart'
    as _i15;
import 'package:cyber_map/core/domain/cubits/osm_object/osm_object_cubit.dart'
    as _i4;
import 'package:cyber_map/core/domain/cubits/route_planner/route_planner_cubit.dart'
    as _i6;
import 'package:cyber_map/core/domain/cubits/user_position/user_position_cubit.dart'
    as _i7;
import 'package:cyber_map/core/domain/repositories/i_key_value_repository.dart'
    as _i11;
import 'package:cyber_map/core/domain/repositories/i_local_osm_repository.dart'
    as _i13;
import 'package:cyber_map/core/domain/repositories/i_osm_repository.dart'
    as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i8;
import 'package:injectable/injectable.dart' as _i2;

const String _dev = 'dev';

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final injectionClientModule = _$InjectionClientModule();
  gh.factory<_i3.MapPositionCubit>(() => _i3.MapPositionCubit());
  gh.factory<_i4.OsmDataCubit>(() => _i4.OsmDataCubit());
  gh.factory<_i5.EmojiTagMapCubit>(() => _i5.EmojiTagMapCubit());
  gh.singleton<_i6.RoutePlannerCubit>(() => _i6.RoutePlannerCubit());
  gh.singleton<_i7.UserPositionCubit>(() => _i7.UserPositionCubit());
  gh.lazySingleton<_i8.Client>(() => injectionClientModule.httpClient);
  gh.factory<_i9.IOSMRepository>(
    () => _i10.OverpassOSMRepository(gh<_i8.Client>()),
    registerFor: {_dev},
  );
  gh.lazySingleton<_i11.IKeyValueRepository>(
      () => _i12.SecureStorageKeyValueRepository());
  gh.factory<_i13.ILocalOSMRepository>(
    () => _i14.SQLiteOSMRepository(),
    registerFor: {_dev},
  );
  gh.singleton<_i15.NavigationRouteCubit>(() => _i15.NavigationRouteCubit(
      userPositionCubit: gh<_i7.UserPositionCubit>()));
  return getIt;
}

class _$InjectionClientModule extends _i16.InjectionClientModule {}
