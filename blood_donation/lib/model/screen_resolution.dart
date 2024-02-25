import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ScreenResolution {
  double sw = MediaQuery.of(context as BuildContext).size.width;
  double sh = MediaQuery.of(context as BuildContext).size.height;
}
