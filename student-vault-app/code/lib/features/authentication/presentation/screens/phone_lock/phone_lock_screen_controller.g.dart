// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_lock_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$phoneLockControllerHash() =>
    r'f0fe6b92b077876b01c8f1988778d824901a5370';

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

abstract class _$PhoneLockController
    extends BuildlessAutoDisposeNotifier<PhoneLockState> {
  late final String unlockReason;

  PhoneLockState build(String unlockReason);
}

/// See also [PhoneLockController].
@ProviderFor(PhoneLockController)
const phoneLockControllerProvider = PhoneLockControllerFamily();

/// See also [PhoneLockController].
class PhoneLockControllerFamily extends Family<PhoneLockState> {
  /// See also [PhoneLockController].
  const PhoneLockControllerFamily();

  /// See also [PhoneLockController].
  PhoneLockControllerProvider call(String unlockReason) {
    return PhoneLockControllerProvider(unlockReason);
  }

  @override
  PhoneLockControllerProvider getProviderOverride(
    covariant PhoneLockControllerProvider provider,
  ) {
    return call(provider.unlockReason);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'phoneLockControllerProvider';
}

/// See also [PhoneLockController].
class PhoneLockControllerProvider
    extends
        AutoDisposeNotifierProviderImpl<PhoneLockController, PhoneLockState> {
  /// See also [PhoneLockController].
  PhoneLockControllerProvider(String unlockReason)
    : this._internal(
        () => PhoneLockController()..unlockReason = unlockReason,
        from: phoneLockControllerProvider,
        name: r'phoneLockControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$phoneLockControllerHash,
        dependencies: PhoneLockControllerFamily._dependencies,
        allTransitiveDependencies:
            PhoneLockControllerFamily._allTransitiveDependencies,
        unlockReason: unlockReason,
      );

  PhoneLockControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.unlockReason,
  }) : super.internal();

  final String unlockReason;

  @override
  PhoneLockState runNotifierBuild(covariant PhoneLockController notifier) {
    return notifier.build(unlockReason);
  }

  @override
  Override overrideWith(PhoneLockController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PhoneLockControllerProvider._internal(
        () => create()..unlockReason = unlockReason,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        unlockReason: unlockReason,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PhoneLockController, PhoneLockState>
  createElement() {
    return _PhoneLockControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PhoneLockControllerProvider &&
        other.unlockReason == unlockReason;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, unlockReason.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PhoneLockControllerRef on AutoDisposeNotifierProviderRef<PhoneLockState> {
  /// The parameter `unlockReason` of this provider.
  String get unlockReason;
}

class _PhoneLockControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<PhoneLockController, PhoneLockState>
    with PhoneLockControllerRef {
  _PhoneLockControllerProviderElement(super.provider);

  @override
  String get unlockReason =>
      (origin as PhoneLockControllerProvider).unlockReason;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
