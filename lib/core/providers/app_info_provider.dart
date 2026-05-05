import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/app_info.dart';

part 'app_info_provider.g.dart';

/// Provider that fetches app version information from pubspec.yaml
@riverpod
Future<PackageInfo> packageInfo(Ref ref) async {
  return await PackageInfo.fromPlatform();
}

/// Provider that returns formatted version string
@riverpod
Future<String> appVersion(Ref ref) async {
  try {
    final packageInfo = await ref.watch(packageInfoProvider.future);
    final version = packageInfo.version;

    // Format version for display (e.g., "0.1.0-beta" becomes "0.1.0 Beta")
    if (version.contains('-')) {
      final parts = version.split('-');
      final versionNumber = parts[0];
      final suffix = parts[1].split('+')[0]; // Remove build number if present
      final capitalizedSuffix = suffix[0].toUpperCase() + suffix.substring(1);
      return '$versionNumber $capitalizedSuffix';
    }

    return version;
  } catch (e) {
    // Fallback to default version if something goes wrong
    return '${AppInfo.defaultVersion} Beta';
  }
}

/// Provider that returns the full version with build number
@riverpod
Future<String> appVersionWithBuild(Ref ref) async {
  try {
    final packageInfo = await ref.watch(packageInfoProvider.future);
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  } catch (e) {
    return '${AppInfo.defaultVersion}+${AppInfo.defaultBuildNumber}';
  }
}
