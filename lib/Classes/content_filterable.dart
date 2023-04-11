import 'package:yts_flutter/classes/misc_types.dart';

abstract class ContentFilterable {
  FirebaseID get filterID;
  String get filterName;
}
