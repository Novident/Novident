import 'package:logging/logging.dart';

typedef TreeLogHandler = void Function(String message);

/// For logging message in Novident
class TreeLogger {
  TreeLogger._({
    required this.name,
  }) : _logger = Logger(name);

  final String name;
  late final Logger _logger;

  /// For example, uses the logger when updating or clearing selection.
  static TreeLogger selection = TreeLogger._(name: 'selection');

  /// For logging message related to an internal node of the root.
  ///
  /// For example, uses the logger when building the widget.
  static TreeLogger internalNodes = TreeLogger._(name: 'node');

  /// For logging message related to root changes.
  ///
  /// For example, uses the logger when building the widget.
  static TreeLogger root = TreeLogger._(name: 'root');

  void error(String message) => _logger.severe(message);
  void warn(String message) => _logger.warning(message);
  void info(String message) => _logger.info(message);
  void debug(String message) => _logger.fine(message);
}

extension on TreeLogLevel {
  Level toLevel() {
    switch (this) {
      case TreeLogLevel.off:
        return Level.OFF;
      case TreeLogLevel.error:
        return Level.SEVERE;
      case TreeLogLevel.warn:
        return Level.WARNING;
      case TreeLogLevel.info:
        return Level.INFO;
      case TreeLogLevel.debug:
        return Level.FINE;
      case TreeLogLevel.all:
        return Level.ALL;
    }
  }

  String get name {
    switch (this) {
      case TreeLogLevel.off:
        return 'OFF';
      case TreeLogLevel.error:
        return 'ERROR';
      case TreeLogLevel.warn:
        return 'WARN';
      case TreeLogLevel.info:
        return 'INFO';
      case TreeLogLevel.debug:
        return 'DEBUG';
      case TreeLogLevel.all:
        return 'ALL';
    }
  }
}

/// Manages log service for [Tree]
///
/// Set the log level and config the handler depending on your need.
class TreeLoggerConfiguration {
  TreeLoggerConfiguration._() {
    Logger.root.onRecord.listen((record) {
      if (handler != null) {
        handler!(
          '[${record.level.toLogLevel().name}][${record.loggerName}]: ${record.time}: ${record.message}',
        );
      }
    });
  }

  factory TreeLoggerConfiguration() => _logConfiguration;

  static final TreeLoggerConfiguration _logConfiguration =
      TreeLoggerConfiguration._();

  TreeLogHandler? handler;

  TreeLogLevel _level = TreeLogLevel.off;

  TreeLogLevel get level => _level;
  set level(TreeLogLevel level) {
    _level = level;
    Logger.root.level = level.toLevel();
  }
}

extension on Level {
  TreeLogLevel toLogLevel() {
    if (this == Level.SEVERE) {
      return TreeLogLevel.error;
    } else if (this == Level.WARNING) {
      return TreeLogLevel.warn;
    } else if (this == Level.INFO) {
      return TreeLogLevel.info;
    } else if (this == Level.FINE) {
      return TreeLogLevel.debug;
    }
    return TreeLogLevel.off;
  }
}

enum TreeLogLevel {
  off,
  error,
  warn,
  info,
  debug,
  all,
}
