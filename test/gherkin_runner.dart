import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:cucumber_google_sheets/utils/map.dart' as utils_map;
import 'package:gherkin/gherkin.dart';
import 'package:googleapis/mybusinessverifications/v1.dart';

/*
done:
Duration
Location
Comment

do these:

Attachment
Envelope
GherkinDocument
Background
DataTable
DocString
Examples
Feature
FeatureChild
Rule
RuleChild
Scenario
Step
TableCell
TableRow
Tag
Hook
Meta
Ci
Git
Product
ParameterType
ParseError
Pickle
PickleDocString
PickleStep
PickleStepArgument
PickleTable
PickleTableCell
PickleTableRow
PickleTag
Source
SourceReference
JavaMethod
JavaStackTraceElement
StepDefinition
StepDefinitionPattern
TestCase
Group
StepMatchArgument
StepMatchArgumentsList
TestStep
TestCaseFinished
TestCaseStarted
TestRunFinished
TestRunStarted
TestStepFinished
TestStepResult
TestStepStarted
Timestamp
UndefinedParameterType

enums
AttachmentContentEncoding
PickleStepType
SourceMediaType
StepDefinitionPatternType
StepKeywordType
TestStepResultStatus
*/

abstract class CucumberMessage {
  Map<String, Object?> encode();
}

/// Base types
class DurationMessage extends CucumberMessage {
  int seconds;
  int nanos;

  DurationMessage(this.seconds, this.nanos);

  @override
  Map<String, Object?> encode() {
    return {
      'seconds': seconds,
      'nanos': nanos,
    };
  }
}

class LocationMessage extends CucumberMessage {
  int line;
  int? column;

  LocationMessage(this.line, [this.column]);

  @override
  Map<String, Object?> encode() {
    return {
      'line': line,
      'column': column,
    };
  }
}

class GitMessage implements CucumberMessage {
  String remote;
  String revision;
  String? branch;
  String? tag;

  GitMessage(this.remote, this.revision, [this.branch, this.tag]);

  @override
  Map<String, Object?> encode() {
    return {
      'remote': remote,
      'revision': revision,
      'branch': branch,
      'tag': tag,
    };
  }
}

class ProductMessage implements CucumberMessage {
  String name;
  String? version;

  ProductMessage(this.name, [this.version]);

  @override
  Map<String, Object?> encode() {
    return {
      'name': name,
      'version': version,
    };
  }
}

class ParameterTypeMessage {
  String id;
  String name;
  List<String> regularExpressions;
  bool preferForRegularExpressionMatch;
  bool useForSnippets;
  ParameterTypeMessage(this.id, this.name, this.regularExpressions,
      this.preferForRegularExpressionMatch, this.useForSnippets);
}

class PickleDocStringMessage {
  String content;
  String? mediaType;
  PickleDocStringMessage(this.content, [this.mediaType]);
}

class PickleTableCell {
  String value;
  PickleTableCell(this.value);
}

class PickleTagMesssage {
  String astNodeId;
  String name;
  PickleTagMesssage(this.astNodeId, this.name);
}

enum AttachmentContentEncoding {
  // ignore: constant_identifier_names
  IDENTITY,
  // ignore: constant_identifier_names
  BASE64,
}

enum PickleStepType {
  // ignore: constant_identifier_names
  Unknown,
  // ignore: constant_identifier_names
  Context,
  // ignore: constant_identifier_names
  Action,
  // ignore: constant_identifier_names
  Outcome,
}

enum SourceMediaType {
  plain, // 'text/x.cucumber.gherkin+plain
  markdown, // text/x.cucumber.gherkin+markdown
}

enum StepDefinitionPatternType {
  // ignore: constant_identifier_names
  CUCUMBER_EXPRESSION,
  // ignore: constant_identifier_names
  REGULAR_EXPRESSION,
}

enum StepKeywordType {
  // ignore: constant_identifier_names
  Unknown,
  // ignore: constant_identifier_names
  Context,
  // ignore: constant_identifier_names
  Action,
  // ignore: constant_identifier_names
  Outcome,
  // ignore: constant_identifier_names
  Conjunction,
}

enum TestStepResultStatus {
  // ignore: constant_identifier_names
  UNKNOWN,
  // ignore: constant_identifier_names
  PASSED,
  // ignore: constant_identifier_names
  SKIPPED,
  // ignore: constant_identifier_names
  PENDING,
  // ignore: constant_identifier_names
  UNDEFINED,
  // ignore: constant_identifier_names
  AMBIGUOUS,
  // ignore: constant_identifier_names
  FAILED,
}

/// Complex types

class AttachmentMessage {
  String body;
  AttachmentContentEncoding contentEncoding;
  String mediaType;
  String? fileName;
  String? testCaseStartedId;
  String? testStepId;
  String? url;
  SourceMessage? source;
  AttachmentMessage(this.body, this.contentEncoding, this.mediaType,
      [this.fileName,
      this.testCaseStartedId,
      this.testStepId,
      this.url,
      this.source]);
}

class CIMessage implements CucumberMessage {
  String name;
  String? url;
  String? buildNumber;
  GitMessage? git;

  CIMessage(this.name, [this.url, this.buildNumber, this.git]);

  @override
  Map<String, Object?> encode() {
    return {
      'name': name,
      'url': url,
      'buildNumber': buildNumber,
      'git': git?.encode(),
    };
  }
}

class MetaMessage implements CucumberMessage {
  String protocolVersion;
  ProductMessage implementation;
  ProductMessage runtime;
  ProductMessage os;
  ProductMessage cpu;
  CIMessage ci;

  MetaMessage(this.protocolVersion, this.implementation, this.runtime, this.os,
      this.cpu, this.ci);

  @override
  Map<String, Object?> encode() {
    return {
      'protocolVersion': protocolVersion,
      'implementation': implementation.encode(),
      'runtime': runtime.encode(),
      'os': os.encode(),
      'cpu': cpu.encode(),
      'ci': ci.encode(),
    };
  }
}

class SourceMessage implements CucumberMessage {
  String uri;
  String data;
  String mediaType;
  // "text/x.cucumber.gherkin+plain"
  // "text/x.cucumber.gherkin+markdown"

  SourceMessage(this.uri, this.data, this.mediaType);

  @override
  Map<String, Object?> encode() {
    return {
      'uri': uri,
      'data': data,
      'mediaType': mediaType,
    };
  }
}

/// Pickles: A `Pickle` represents a template for a `TestCase`.
/// It is typically derived from another format, such as [GherkinDocument](#io.cucumber.messages.GherkinDocument).
/// In the future a `Pickle` may be derived from other formats such as Markdown or
/// Excel files.  By making `Pickle` the main data structure Cucumber uses for execution,
/// the implementation of Cucumber itself becomes simpler, as it doesn't have to deal\n with the complex structure
/// of a [GherkinDocument](#io.cucumber.messages.GherkinDocument).
/// Each `PickleStep` of a `Pickle` is matched with a `StepDefinition` to create a `TestCase`
class PickleMessage {}

class CommentMessage {
  String text;
  LocationMessage location;

  CommentMessage(this.text, this.location);

  @override
  Map<String, Object?> encode() {
    return {
      'text': text,
      'location': location,
    };
  }
}

class FeatureMessage2 {
  LocationMessage location;
  List<TagMessage> tags = [];
  String name;
  String description;
  String keyword;
  String language;
  List<FeatureChildMessage> children = [];
  FeatureMessage2(this.location, this.tags, this.name, this.description,
      this.keyword, this.language, this.children);
}

class TagMessage {
  String id;
  String name;
  LocationMessage location;
  TagMessage(this.id, this.name, this.location);
}
class DocStringMessage {
  Location location;
  String delimeter;
  String content;
  String? mediaType;

  DocStringMessage(this.location, this.delimeter, this.content, [this.mediaType]);
}

class StepMessage2 {
  LocationMessage location;
  String keyword;
  String text;
  StepKeywordType? keywordType;
  DocStringMessage? docString;

}
class BackgroundMessage {
  LocationMessage location;
  String keyword;
  String name;
  String description;
  String id;
  List<StepMessage2> steps;
  BackgroundMessage(this.location, this.keyword, this.name, this.description, this.id, this.steps);
}
class RuleChildMessage {
  BackgroundMessage
}

class RuleMessage {
  String id;
  String keyword;
  String name;
  String description;
  LocationMessage location;
  List<TagMessage> tags;
  List<RuleChildMessage> children;
  RuleMessage(this.id, this.keyword, this.name, this.description, this.location,
      this.tags, this.children);
}

class FeatureChildMessage {}

class GherkinDocumentMessage {
  List<CommentMessage> comments = [];
  FeatureMessage2? feature;
  String? uri;
  GherkinDocumentMessage(this.comments, [this.feature, this.uri]);
}

class EnvelopeMessage implements CucumberMessage {
  MetaMessage? meta;
  SourceMessage? source;

  static createMeta(MetaMessage m) {
    final e = EnvelopeMessage();
    e.meta = m;
    return e;
  }

  static createSource(SourceMessage m) {
    final e = EnvelopeMessage();
    e.source = m;
    return e;
  }

  @override
  Map<String, Object?> encode() {
    return {
      'meta': meta?.encode(),
      'source': source?.encode(),
    };
  }

  String serialize() {
    return jsonEncode(utils_map.suppressNulls(encode()));
  }
}

/// Compatible with the cucumber standard as per this https://github.com/cucumber/common/tree/main/messages
class NdjsonReporter extends FullReporter {
  final List<EnvelopeMessage> messages = [];
  final String fileLocation;

  NdjsonReporter(this.fileLocation);

  @override
  Future<void> message(String message, MessageLevel level) async {
    // print(message);
  }

  @override
  Future<void> dispose() async {
    print('Created ${messages.length} messages');
    final f = File(fileLocation);
    await f.writeAsString(messages.map((m) => m.serialize()).join('\n'));
  }

  @override
  ReportActionHandler<FeatureMessage> get feature {
    return ReportActionHandler(
        onStarted: ([featureMessage]) async {
          String filePath = (featureMessage?.context.filePath) ?? 'uri-missing';
          // ignore: todo
          // TODO: make a PR to include context. This is missing the entire document.
          String data = featureMessage?.context.lineText ?? 'document missing';
          messages.add(EnvelopeMessage.createSource(
              SourceMessage(filePath, data, 'text/x.cucumber.gherkin+plain')));
        },
        onFinished: ([featureMessage]) async {});
  }

  @override
  ReportActionHandler<ScenarioMessage> get scenario {
    return ReportActionHandler(
        onStarted: ([scenarioMessage]) async {},
        onFinished: ([scenarioMessage]) async {});
  }

  @override
  ReportActionHandler<StepMessage> get step {
    return ReportActionHandler(
        onStarted: ([stepMessage]) async {},
        onFinished: ([stepMessage]) async {});
  }

  @override
  ReportActionHandler<TestMessage> get test {
    return ReportActionHandler(
        onStarted: ([testMessage]) async {
          messages.add(EnvelopeMessage.createMeta(MetaMessage(
              '19.1.2',
              ProductMessage('1.0.0', 'cucumber-message-reporter'),
              ProductMessage('dart', Platform.version),
              ProductMessage(
                  Platform.operatingSystem, Platform.operatingSystemVersion),
              ProductMessage('x64'),
              CIMessage('origin', 'abc', 'main'))));
        },
        onFinished: ([testMessage]) async {});
  }

  @override
  Future<void> onException(Object exception, StackTrace stackTrace) async {
    print(exception.toString());
  }
}

Future<void> main() {
  final config = TestConfiguration(
    features: [RegExp(r"features/.*\.feature")],
    reporters: [NdjsonReporter('report.json')],
    tagExpression: '@auto',
    stepDefinitions: [],
    stopAfterTestFailed: true,
  );

  return GherkinRunner().execute(config);
}
