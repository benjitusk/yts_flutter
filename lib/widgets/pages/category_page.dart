import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/widgets/content_table_row.dart';
import 'package:yts_flutter/widgets/pages/category_page_model.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key, required this.category}) {
    this.model = CategoryPageModel(category: category);
    this.model.loadContent();
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

            if (model.error != null)
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text(
                            'Error: ${model.error.toString()}. Please try again.'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ));
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
                  return ContentTableRow(shiur: model.content![index]);
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: model.subCategories!.length + model.content!.length);
          },
        ));
  }
}
