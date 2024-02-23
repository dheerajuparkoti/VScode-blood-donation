import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int? _userId;
  int? _donorId;
  String? _userAccountType;

  int? get userId => _userId;
  int? get donorId => _donorId;
  String? get accountType => _userAccountType;

  // retrieve userId during login
  void setUserId(int uid) {
    _userId = uid;

    notifyListeners();
  }

  // retrieve userDonorId during login
  void setDonorId(int did) {
    _donorId = did;

    notifyListeners();
  }

  // retrieve userAccountType during login
  void setUserAccountType(String uac) {
    _userAccountType = uac;

    notifyListeners();
  }
}
