import 'dart:io';
import 'package:googleapis_auth/auth_io.dart' as auth_io;
import 'package:cucumber_google_sheets/cucumber_google_sheets.dart' as cucumber_google_sheets;
import 'package:cucumber_google_sheets/google_auth.dart' as google_auth;

void main(List<String> arguments) async {
  auth_io.AuthClient client = await google_auth.obtainAuthenticatedClient();
  Map<String, String> env = Platform.environment;
  
  print('Hello world: ${cucumber_google_sheets.calculate()}! ${env['GOOGLE_SHEET_ID']}');
  // await client.close();
}
