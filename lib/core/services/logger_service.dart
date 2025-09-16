import 'package:logger/logger.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();

  factory LoggerService() {
    return _instance;
  }

  LoggerService._internal();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  void d(dynamic message) => _logger.d(message);     // debug
  void i(dynamic message) => _logger.i(message);     // info
  void w(dynamic message) => _logger.w(message);     // warning
  void e(dynamic message) => _logger.e(message);     // error
  void v(dynamic message) => _logger.v(message);     // verbose
}
