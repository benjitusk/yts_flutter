import 'package:flutter/foundation.dart';
import 'package:yts_flutter/Classes/Streamable.dart';

class StreamableNotifier extends ValueNotifier<Streamable?> {
  static const _initialValue = null;
  StreamableNotifier() : super(_initialValue);
}
