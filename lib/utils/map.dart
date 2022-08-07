import 'package:fpdart/fpdart.dart' as fp;

/// json decoder returns dynamic, but a true json doc has
/// all keys at the root of the document, no top-level arrays allowed.
fp.Either<String, Map<String, dynamic>> pseudoJsonToTrueJson(dynamic pseudoJson) {
  try {
    final result = <String, dynamic>{};
    // This line will fail if doc is like [{ "k": "v" }, ...]
    pseudoJson.forEach((key, value) {
      if (key is String) {
        result[key] = pseudoJson[key];
      } else {
        return fp.left('Json doc had non-string key');
      }
    });
    return fp.Either.right(result);
  } catch (e, s) {
    return fp.left('Error');
  }
}
