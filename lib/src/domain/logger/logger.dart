import 'package:logging/logging.dart';

typedef NovLogHandler = void Function(String message);

/// For logging message in Novident
///
/// We use it to debug the tree view,
/// corkboard, editor, and compilations
/// process
class NovidentLogger {
  NovidentLogger._({
    required this.name,
  }) : _logger = Logger(name);

  final String name;
  late final Logger _logger;

  static NovidentLogger editor = NovidentLogger._(name: 'editor');

  static NovidentLogger treeView = NovidentLogger._(name: 'tree');

  static NovidentLogger corkboard = NovidentLogger._(name: 'corkboard');

  static NovidentLogger compilation = NovidentLogger._(name: 'compilation');

  static NovidentLogger processor = NovidentLogger._(name: 'processor');

  void error(String message) => _logger.severe(message);
  void warn(String message) => _logger.warning(message);
  void info(String message) => _logger.info(message);
  void debug(String message) => _logger.fine(message);
}

extension on NovidentLogLevel {
  Level toLevel() {
    switch (this) {
      case NovidentLogLevel.off:
        return Level.OFF;
      case NovidentLogLevel.error:
        return Level.SEVERE;
      case NovidentLogLevel.warn:
        return Level.WARNING;
      case NovidentLogLevel.info:
        return Level.INFO;
      case NovidentLogLevel.debug:
        return Level.FINE;
      case NovidentLogLevel.all:
        return Level.ALL;
    }
  }

  String get name {
    switch (this) {
      case NovidentLogLevel.off:
        return 'OFF';
      case NovidentLogLevel.error:
        return 'ERROR';
      case NovidentLogLevel.warn:
        return 'WARN';
      case NovidentLogLevel.info:
        return 'INFO';
      case NovidentLogLevel.debug:
        return 'DEBUG';
      case NovidentLogLevel.all:
        return 'ALL';
    }
  }
}

/// Manages log service for [Tree]
///
/// Set the log level and config the handler depending on your need.
class NovidentLoggerConfiguration {
  NovidentLoggerConfiguration._() {
    Logger.root.onRecord.listen((record) {
      if (handler != null) {
        handler!(
          '[${record.level.toLogLevel().name}][${record.loggerName}]: ${record.time}: ${record.message}',
        );
      }
    });
  }

  factory NovidentLoggerConfiguration() => _logConfiguration;

  static final NovidentLoggerConfiguration _logConfiguration =
      NovidentLoggerConfiguration._();

  NovLogHandler? handler;

  NovidentLogLevel _level = NovidentLogLevel.off;

  NovidentLogLevel get level => _level;
  set level(NovidentLogLevel level) {
    _level = level;
    Logger.root.level = level.toLevel();
  }
}

extension on Level {
  NovidentLogLevel toLogLevel() {
    if (this == Level.SEVERE) {
      return NovidentLogLevel.error;
    } else if (this == Level.WARNING) {
      return NovidentLogLevel.warn;
    } else if (this == Level.INFO) {
      return NovidentLogLevel.info;
    } else if (this == Level.FINE) {
      return NovidentLogLevel.debug;
    }
    return NovidentLogLevel.off;
  }
}

enum NovidentLogLevel {
  off,
  error,
  warn,
  info,
  debug,
  all,
}
