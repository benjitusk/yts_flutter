import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/favorites_manager.dart';
import 'package:yts_flutter/widgets/content_table_row.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FavoritesManager().favoritesStream,
        builder: (context, _) {
          return ListView.separated(
            itemBuilder: (context, index) => ContentTableRow(
              shiur: FavoritesManager().favorites[index],
              // showAuthor: false,
              showFav: false,
            ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: FavoritesManager().favorites.length,
          );
        });
  }
}
