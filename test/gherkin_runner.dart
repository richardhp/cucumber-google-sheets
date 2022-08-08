import 'dart:async';
import 'package:gherkin/gherkin.dart';

Future<void> main() {
  final config = TestConfiguration(
    features: [RegExp(r"features/.*\.feature")],
    reporters: [
      StdoutReporter(MessageLevel.error),
      ProgressReporter(),
      TestRunSummaryReporter(),
    ],
    tagExpression: '@auto',
    stepDefinitions: [],
    stopAfterTestFailed: true,
  );

  return GherkinRunner().execute(config);
}
