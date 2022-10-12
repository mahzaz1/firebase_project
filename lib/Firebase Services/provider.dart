import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _obsecureValue = true;
  bool get obsecureValue => _obsecureValue;

  setObsecure() {
    _obsecureValue = !_obsecureValue;
    notifyListeners();
  }


  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }
}
