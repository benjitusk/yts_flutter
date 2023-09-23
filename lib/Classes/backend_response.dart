import 'package:yts_flutter/classes/misc_types.dart';

class BackendResponse<T> {
  final T result;
  // final Error? error;
  final FirebaseDoc? firstDocOfNextPage;
  final bool hasMore;

  BackendResponse({
    required this.result,
    this.firstDocOfNextPage,
    this.hasMore = false,
  });
}
