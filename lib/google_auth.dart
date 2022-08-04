import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart' as auth_io;


Future<Map> readJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  return jsonDecode(input);
}

Future<auth_io.AuthClient> obtainAuthenticatedClient() async {
  Map json = await readJsonFile('/data/google-api-keys.json');
  print(json);
  final accountCredentials = auth_io.ServiceAccountCredentials.fromJson(json);
  List<String> scopes = [];

  auth_io.AuthClient client = await auth_io.clientViaServiceAccount(accountCredentials, scopes);

  return client; // Remember to close the client when you are finished with it.
}