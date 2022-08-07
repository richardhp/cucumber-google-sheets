import 'dart:io' as io;
import 'dart:convert' as convert;
import 'package:fpdart/fpdart.dart' as fp;
import 'package:cucumber_google_sheets/utils/map.dart' as utils_map;
import 'package:cucumber_google_sheets/utils/list.dart' as utils_list;
import 'package:cucumber_google_sheets/utils/fp.dart' as utils_fp;
/// This module will be responsible for parsing the gherkin messages and extracting the information we are interested in

enum MessageType {
  attachment,
  duration,
  envelop,
  gherkinDocument,
  background,
  comment,
  dataTable,
  docString,
  examples,
  feature,
  featureChild,
  rule,
  ruleChild,
  scenario,
  step,
  tableCell,
  tableRow,
  tag,
  hook,
  location,
  meta,
  ci,
  git,
  product,
  parameterType,
  parseError,
  pickle,
  pickleDocString,
  pickleStep,
  pickleStepArgument,
  pickleTable,
  pickleTableCell,
  pickleTableRow,
  pickleTag,
  source,
  sourceReference,
  javaMethod,
  javaStackTraceElement,
  stepDefinition,
  stepDefinitionPattern,
  testCase,
  group,
  stepMatchArgument,
  testStep,
  testCaseFinished,
  testRunFinished,
  testRunStarted,
  testStepFinished,
  testStepResult,
  testStepStarted,
  timestamp,
  undefinedParameterType,
  attachmentContentEncoding,
  pickleStepType,
  sourceMediaType,
  stepDefinitionPatternType,
  stepKeywordType,
  testStepResultStatus,
}

// Note, if loading the entire file runs out of memory, load them one by one like so:
// import 'dart:async';
// import 'dart:io';
// import 'dart:convert';
// new File(path)
//     .openRead()
//     .transform(utf8.decoder)
//     .transform(new LineSplitter())
//     .forEach((l) => print('line: $l'));

/// This will return a list of messages
fp.TaskEither<String, String> loadMessageFile() {
  return fp.TaskEither.tryCatch(() async {
    return await io.File('/data/cucumber-messages.json').readAsString();
  }, (error, stackTrace) => 'FileSystemException');
}

/// This will attempt to split the file and decode each line as json
fp.Either<String, List<dynamic>> decodeMessages(String messageData) {
  try {
    final lines = messageData.split('\n');
    final decodedMessages = utils_fp
    .sequenceEither(
      lines
        .map(convert.jsonDecode)
        .map(utils_map.pseudoJsonToTrueJson)
        .toList()
    );
    return decodedMessages;
    // Each message must be a true json document in its own right
  } catch (e) {
    return fp.Either.left('Failed to decode messages');
  }
}

/// If successful, it will determine the message type
fp.Either<String, MessageType> getMessageType(Map<String, dynamic> message) {
  try {
    final firstKey = message.keys.first;
    MessageType m = MessageType.values.firstWhere((element) => element.toString() == 'MessageType.$firstKey');
    return fp.Either.right(m);
  } on StateError {
    return fp.Either.left('Could not match message type');
  }
}



String consumeMessage(String json) {
  return '';
}
