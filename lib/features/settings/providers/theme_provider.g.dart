// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeMode)
final themeModeProvider = ThemeModeProvider._();

final class ThemeModeProvider
    extends $NotifierProvider<ThemeMode, ThemeModeEnum> {
  ThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeHash();

  @$internal
  @override
  ThemeMode create() => ThemeMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeModeEnum value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeModeEnum>(value),
    );
  }
}

String _$themeModeHash() => r'fe160d4ff090749d23d6e6db6c09d8c135758c5d';

abstract class _$ThemeMode extends $Notifier<ThemeModeEnum> {
  ThemeModeEnum build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ThemeModeEnum, ThemeModeEnum>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeModeEnum, ThemeModeEnum>,
              ThemeModeEnum,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
