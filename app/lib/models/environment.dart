import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class Environment {
  static String get privateKey {
    return dotenv.env["PRIVATE_KEY"] ?? "KEY not found";
  }
}
