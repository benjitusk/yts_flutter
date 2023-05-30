import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/content_table_row.dart';
import 'package:yts_flutter/widgets/screens/favorites_screen_model.dart';
// import 'package:yts_flutter/widgets/content_table_row.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});
  final model = FavoritesScreenModel();

  // @override
  void dispose() {
    model.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, child) {
          if (model.favorites == null) {
            return const Center(child: CircularProgressIndicator());
          } else
            return ListView.separated(
              itemBuilder: (context, index) => ContentTableRow(
                shiur: model.favorites![index],
                // showAuthor: false,
                showFav: false,
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: model.favorites!.length,
            );
        });
  }
}
