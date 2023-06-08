import 'package:yts_flutter/classes/misc_types.dart';

class BackendResponse<T> {
  final T result;
  // final Error? error;
  final FirebaseDoc? lastDoc;

  BackendResponse({
    required this.result,
    // this.error,
    this.lastDoc,
  });
}
