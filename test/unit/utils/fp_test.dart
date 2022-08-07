import 'package:test/test.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:cucumber_google_sheets/utils/fp.dart' as lib;

void main() {
  group('either', () {
    test('all rights', () {
      final listOfEithers = [fp.Either.right(1), fp.Either.right(2), fp.Either.right(3)];
      final result = lib.sequenceEither(listOfEithers);
      expect(result.isRight(), true);
      expect(result.getOrElse((l) => []), [1, 2, 3]);
    });
    test('one left', () {
      final listOfEithers = [fp.Either.right(1), fp.Either.left(2), fp.Either.right(3)];
      final result = lib.sequenceEither(listOfEithers);
      expect(result.isRight(), false);
      expect(result.getLeft(), fp.Option.of(2));
    });
  });
}
