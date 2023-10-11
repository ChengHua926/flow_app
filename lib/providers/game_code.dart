import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameCodeProvider with ChangeNotifier {
  String _code = "524183";

  String get code => _code;

  set code(String value) {
    _code = value;
    notifyListeners();
  }

  void updateCode(String newCode) {
    _code = newCode;
    notifyListeners();
  }
}
