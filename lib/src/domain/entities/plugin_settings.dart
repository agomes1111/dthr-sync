abstract class PluginSettings {
  String api_url;
  bool autoSync;
  int syncJobInterval;
  PluginSettings(
    this.api_url,
    this.autoSync,
    this.syncJobInterval,
  );
}
