import 'package:cucumber_google_sheets/gherkin_message_parser.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(consumeMessage(''), '');
  });
}
