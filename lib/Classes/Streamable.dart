import 'package:yts_flutter/classes/misc_types.dart';

abstract class Streamable {
  FirebaseID get authorID;
  String get title;
  String get id;
  Duration get duration;
  DateTime get date;

  Future<URL?> getStreamableURL();
}
