import 'package:googleapis/sheets/v4.dart' as google_sheets;

import 'package:cucumber_google_sheets/google_auth.dart' as google_auth;
import 'package:cucumber_google_sheets/config.dart' as config;

void main(List<String> arguments) async {
  final env = new config.Config();
  final client = await google_auth.obtainAuthenticatedClient();
  final api = google_sheets.SheetsApi(client);
  final spreadsheet = await api.spreadsheets.get(env.GOOGLE_SHEET_ID);
  final sheets = spreadsheet.sheets;

  if (sheets != null) {
    print('We have: ${sheets.length} sheets in sheet: ${env.GOOGLE_SHEET_ID}');
  }
  client.close();
}
