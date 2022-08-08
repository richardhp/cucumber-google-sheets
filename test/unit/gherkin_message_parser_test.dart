import 'package:test/test.dart';
import 'dart:convert' as convert;
import 'package:fpdart/fpdart.dart' as fp;
import 'package:cucumber_google_sheets/gherkin_message_parser.dart' as lib;

void main() {
  test('getMessageType', () {
    final rawMessage = '{"meta":{"protocolVersion":"19.1.2","implementation":{"version":"8.5.1","name":"cucumber-js"},"cpu":{"name":"x64"},"os":{"name":"linux","version":"5.4.0-122-generic"},"runtime":{"name":"node.js","version":"18.2.0"}}}';
    expect(lib.getMessageType(convert.jsonDecode(rawMessage)), fp.Either.right(lib.MessageType.meta));
  });

  group('decodeMessages', () {
    test('valid messages', () {
      final rawMessages = '{"meta": "hello"}\n{"number": 32}';
      final decoded = lib.decodeMessages(rawMessages);
      expect(decoded.getRight().getOrElse(() => <Map<String, dynamic>>[])[0]['meta'], 'hello');
    });

    test('invalid messages', () {
      final rawMessages = '{"meta": "hello"}\n[{"number": 32}]';
      final decoded = lib.decodeMessages(rawMessages);
      expect(decoded.isLeft(), true);
    });
  });
}
