import 'package:collection/collection.dart';
import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:novident_remake/src/domain/extensions/string_extension.dart';

extension CapitalizeDeltaExtension on Delta {
  Delta toUppercase(int toUppercaseIndex) {
    if (operations.isEmpty) return this;
    final Delta denormalized = denormalize();
    final List<Operation> ops = <Operation>[];
    for (int i = 0; i < denormalized.length; i++) {
      final Operation op = denormalized.elementAt(i);
      final Object? data = op.data;
      // just add the rest of the operations
      if (toUppercaseIndex <= 0) {
        ops.add(op);
        continue;
      }
      // we need to ignore always the new lines
      if (data is String && data != '\n') {
        final (String content, int lastTaked) = data.capitalizeByIndex(
          endIndex: toUppercaseIndex,
        );
        // give the last index for avoid all
        // content be uppercased by the index
        // isn't decreased
        toUppercaseIndex = lastTaked;
        ops.add(Operation.insert(content, op.attributes));
        continue;
      }
      ops.add(op);
    }
    return Delta.fromOperations(ops).normalize();
  }
}

extension DeltaNormalizer on Delta {
  /// Fully normalizes the operations within the Delta.
  Delta normalize() {
    Delta newDelta = Delta();
    for (var op in operations) {
      newDelta.push(op);
    }
    return newDelta;
  }
}

/// Extension on `Delta` to denormalize operations within a Quill Delta object.
extension DeltaDenormilazer on Delta {
  /// Denormalizes the operations within the Delta.
  ///
  /// Converts each operation in the Delta to a fully expanded form,
  /// where operations that contain newlines are split into separate operations.
  Delta denormalize() {
    if (isEmpty) return this;

    final List<Map<String, dynamic>> denormalizedOps = map<List<Map<String, dynamic>>>(
      (Operation op) => _denormalize(
        op.toJson(),
      ),
    ).flattened.toList();
    return Delta.fromOperations(
        denormalizedOps.map<Operation>((e) => Operation.fromJson(e)).toList());
  }

  /// Denormalizes a single operation map by splitting newlines into separate operations.
  ///
  /// [op] is a Map representing a single operation within the Delta.
  List<Map<String, dynamic>> _denormalize(Map<String, dynamic> op) {
    const newLine = '\n';
    final insertValue = op['insert'];
    if (insertValue is Map ||
        insertValue == newLine ||
        !insertValue.toString().contains('\n')) {
      return <Map<String, dynamic>>[op];
    }

    final List<String> newlinedArray = tokenizeWithNewLines(insertValue.toString());

    if (newlinedArray.length == 1) {
      return <Map<String, dynamic>>[op];
    }

    // Copy op to retain its attributes, but replace the insert value with a newline.
    final Map<String, dynamic> nlObj = <String, dynamic>{
      ...op,
      ...<String, String>{'insert': newLine}
    };

    return newlinedArray.map((String line) {
      if (line == newLine) {
        return nlObj;
      }
      return <String, dynamic>{
        ...op,
        ...<String, String>{'insert': line},
      };
    }).toList();
  }
}

///  Splits by new line character ("\n") by putting new line characters into the
///  array as well. Ex: "hello\n\nworld\n " => ["hello", "\n", "\n", "world", "\n", " "]
List<String> tokenizeWithNewLines(String str, {String newLine = '\n'}) {
  if (str == newLine) {
    return <String>[str];
  }

  List<String> lines = str.split(newLine);

  if (lines.length == 1) {
    return lines;
  }

  int lastIndex = lines.length - 1;

  return lines.foldIndexed(<String>[], (int ind, List<String> pv, String line) {
    if (ind != lastIndex) {
      if (line != '') {
        pv
          ..add(line)
          ..add(newLine);
      } else {
        pv.add(newLine);
      }
    } else if (line != '') {
      pv.add(line);
    }
    return pv;
  });
}
