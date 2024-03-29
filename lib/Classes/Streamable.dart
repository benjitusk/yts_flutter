import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/misc_types.dart';

abstract class Streamable {
  FirebaseID get authorID;
  String get title;
  String get id;
  Duration get duration;
  DateTime get date;
  BasicAuthor get author;
  URL? get cachedURL;
  URL? cachedShareURL = null;

  bool operator ==(Object other) {
    return other is Streamable && other.id == this.id;
  }

  Future<URL?> getShareLink();

  Future<URL?> getStreamableURL();
}
