import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/content_table_row.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Categories/category_page_model.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key, required this.category}) {
    this.model = CategoryPageModel(category: category);
    this.model.initialLoad();
  }
  final Category category;
  late final CategoryPageModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(category.displayName),
        ),
        body: ListenableBuilder(
          listenable: model,
          builder: (context, _) {
            if (model.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (model.isEmpty)
              return const Center(child: Text('No content found.'));
            return ListView.separated(
                itemBuilder: (context, index) {
                  if (index < model.subCategories!.length) {
                    return ListTile(
                      leading: Icon(Icons.folder),
                      title: Text(model.subCategories![index].displayName),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                  category: model.subCategories![index]))),
                    );
                  }
                  if (index <
                      model.subCategories!.length + model.content!.length)
                    return ContentTableRow(shiur: model.content![index]);

                  if (model.isLoadingMore) {
                    return Center(
                        child: Container(
                            margin: const EdgeInsets.all(8),
                            child: const CircularProgressIndicator()));
                  }
                  if (model.hasMore) {
                    return ElevatedButton(
                        onPressed: () => model.loadMore(),
                        child: const Text('Load more'));
                  }
                  return const SizedBox.shrink();
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount:
                    model.subCategories!.length + model.content!.length + 1);
          },
        ));
  }
}
