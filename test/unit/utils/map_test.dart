import 'package:test/test.dart';
import 'dart:convert' as convert;
import 'package:cucumber_google_sheets/utils/map.dart' as lib;

void main() {
  test('pseudoJsonToTrueJson works', () {
    final rawMessage = '{"meta":{"protocolVersion":"19"}}';
    final decodedMessage = convert.jsonDecode(rawMessage);
    final result = lib.pseudoJsonToTrueJson(decodedMessage);
    expect(result.isRight(), true);
  });
  test('pseudoJsonToTrueJson fails', () {
    final rawMessage = '[{"meta":{"protocolVersion":"19"}}]';
    final decodedMessage = convert.jsonDecode(rawMessage);
    final result = lib.pseudoJsonToTrueJson(decodedMessage);
    expect(result.isRight(), false);
  });
}
