import 'package:cucumber_google_sheets/cucumber_google_sheets.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });
}
