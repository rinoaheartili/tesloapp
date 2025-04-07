import 'package:logger/logger.dart';

enum LogLevel {info, debug, warning, error}
final Logger logger = Logger();

class LoggerImpl
{

  static void log(String message, {LogLevel level = LogLevel.info}) 
  {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = _getPrefix(level);
    logger.i('$timestamp [$prefix] $message');
  }

  static String _getPrefix(LogLevel level) 
  {
    switch (level) 
    {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.info:
        return 'INFO';
    }
  }
}