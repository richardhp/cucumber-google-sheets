import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart' as auth_io;

/// This will load a json file and decode it
Future<Map> readJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  return jsonDecode(input);
}

/// This will parse the json settings file and use it to create a client to google
Future<auth_io.AuthClient> obtainAuthenticatedClient() async {
  Map json = await readJsonFile('/data/google-api-keys.json');
  final accountCredentials = auth_io.ServiceAccountCredentials.fromJson(json);
  List<String> scopes = ['https://www.googleapis.com/auth/spreadsheets'];

  auth_io.AuthClient client = await auth_io.clientViaServiceAccount(accountCredentials, scopes);

  return client; // Remember to close the client when you are finished with it.
}