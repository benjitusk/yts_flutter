import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class RebbeimRowModel extends ChangeNotifier {
  final List<Author> rebbeim = [];

  Future<void> load() async {
    return BackendManager.loadAuthors().then((response) {
      final authors = response.result;
      rebbeim.clear();
      // Sort by last name
      authors.sort((lhs, rhs) =>
          lhs.name.split(" ").last.compareTo(rhs.name.split(" ").last));
      Author.addToRegistry(authors);
      rebbeim.addAll(authors);
      notifyListeners();
    });
  }
}
