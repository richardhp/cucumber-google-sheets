import 'dart:io';
import 'package:cucumber_google_sheets/cucumber_google_sheets.dart' as cucumber_google_sheets;

void main(List<String> arguments) {
  Map<String, String> env = Platform.environment;
  
  print('Hello world: ${cucumber_google_sheets.calculate()}! ${env['GOOGLE_SHEET']}');
}
