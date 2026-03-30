// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$citiesNotifierHash() => r'ac182373cb6739d9ef656ac0983f3f9323550044';

/// See also [CitiesNotifier].
@ProviderFor(CitiesNotifier)
final citiesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CitiesNotifier, List<CityEntity>>.internal(
      CitiesNotifier.new,
      name: r'citiesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$citiesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CitiesNotifier = AutoDisposeAsyncNotifier<List<CityEntity>>;
String _$areasNotifierHash() => r'299d6dd08741936a8bef6da953ccc5e51518600f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$AreasNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<AreaEntity>> {
  late final String cityId;

  FutureOr<List<AreaEntity>> build(String cityId);
}

/// See also [AreasNotifier].
@ProviderFor(AreasNotifier)
const areasNotifierProvider = AreasNotifierFamily();

/// See also [AreasNotifier].
class AreasNotifierFamily extends Family<AsyncValue<List<AreaEntity>>> {
  /// See also [AreasNotifier].
  const AreasNotifierFamily();

  /// See also [AreasNotifier].
  AreasNotifierProvider call(String cityId) {
    return AreasNotifierProvider(cityId);
  }

  @override
  AreasNotifierProvider getProviderOverride(
    covariant AreasNotifierProvider provider,
  ) {
    return call(provider.cityId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'areasNotifierProvider';
}

/// See also [AreasNotifier].
class AreasNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<AreasNotifier, List<AreaEntity>> {
  /// See also [AreasNotifier].
  AreasNotifierProvider(String cityId)
    : this._internal(
        () => AreasNotifier()..cityId = cityId,
        from: areasNotifierProvider,
        name: r'areasNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$areasNotifierHash,
        dependencies: AreasNotifierFamily._dependencies,
        allTransitiveDependencies:
            AreasNotifierFamily._allTransitiveDependencies,
        cityId: cityId,
      );

  AreasNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cityId,
  }) : super.internal();

  final String cityId;

  @override
  FutureOr<List<AreaEntity>> runNotifierBuild(
    covariant AreasNotifier notifier,
  ) {
    return notifier.build(cityId);
  }

  @override
  Override overrideWith(AreasNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AreasNotifierProvider._internal(
        () => create()..cityId = cityId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cityId: cityId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AreasNotifier, List<AreaEntity>>
  createElement() {
    return _AreasNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AreasNotifierProvider && other.cityId == cityId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cityId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AreasNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<AreaEntity>> {
  /// The parameter `cityId` of this provider.
  String get cityId;
}

class _AreasNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<AreasNotifier, List<AreaEntity>>
    with AreasNotifierRef {
  _AreasNotifierProviderElement(super.provider);

  @override
  String get cityId => (origin as AreasNotifierProvider).cityId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
