/// Central location for app information and metadata.
///
/// The version is automatically fetched from pubspec.yaml at runtime
/// using the package_info_plus package.
class AppInfo {
  // App Identity
  static const String appName = 'Tally';
  static const String appDescription =
      'Your personal productivity companion that helps you stay on top of your tasks and projects.';

  // Version info - will be fetched dynamically from pubspec.yaml
  // Default fallback values
  static const String defaultVersion = '0.1.0';
  static const String defaultBuildNumber = '1';

  // App URLs and Links (for future use)
  static const String websiteUrl = '';
  static const String supportEmail = '';
  static const String privacyPolicyUrl = '';
  static const String termsOfServiceUrl = '';

  // Copyright
  static String get copyrightYear => DateTime.now().year.toString();
  static String get copyrightText => '© $copyrightYear $appName';
}
