import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:cucumber_google_sheets/utils/map.dart' as utils_map;
import 'package:gherkin/gherkin.dart';

abstract class CucumberMessage {
  Map<String, Object?> encode();
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
    // print(level);
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
          print(featureMessage?.context.filePath);
          String filePath = (featureMessage?.context.filePath) ?? 'uri-missing';
          messages.add(EnvelopeMessage.createSource(SourceMessage(
              filePath, 'data', 'text/x.cucumber.gherkin+plain')));
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
              ProductMessage('dart', '2.17.6'),
              ProductMessage('darwin', '21.4.0'),
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
