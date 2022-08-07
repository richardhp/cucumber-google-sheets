
/// A test run is done against a version of the product
/// It produces a report with a % pass fail rate and a breakdown
/// of which features and scenarios were passing
class TestReport {
  int majorVersion = 0;
  int minorVersion = 0;
  int patchVersion = 0;

  Map<String, Feature> features = <String, Feature>{};

  int passedTests() {
    return 0;
  }

  int totalTests() {
    return 0;
  }

  double passRate() {
    if (totalTests() == 0) {
      return 0;
    } else {
      return passedTests() / totalTests();
    }
  }
}

class Feature {
  String name = '';
}

enum TestStatus { 
  passed,
  failed,
  pending,
}

class Scenario {
  String name = '';
  TestStatus status = TestStatus.pending;
}

class ScenarioStep {
  String statement = '';
  TestStatus status = TestStatus.pending;
}