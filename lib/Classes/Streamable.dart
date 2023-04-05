import 'package:yts_flutter/classes/author.dart';

abstract class Streamable {
  late String playbackUrl;
  late BasicAuthor author;
  late String title;
  late String id;
  late Duration duration;
  late DateTime date;
}
