import 'dart:io' as io;

class Config {
  List<String> requiredEnvVars = ['GOOGLE_SHEET_ID', 'OUTPUT_CSV', 'OUTPUT_GOOGLE'];
  String GOOGLE_SHEET_ID = '';

  Config() {
    Map<String, String> env = io.Platform.environment;
    for (var envVar in  requiredEnvVars) {
      if (!env.containsKey(envVar)) {
        throw '${envVar} missing from env';
      }
    }
    this.GOOGLE_SHEET_ID = env['GOOGLE_SHEET_ID']!;
  }
}