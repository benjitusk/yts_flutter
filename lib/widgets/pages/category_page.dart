import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/services/backend_manager.dart';
import 'package:yts_flutter/widgets/cards/standard_shiur_card.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.category});
  final Category category;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // State variables:
  List<Shiur>? content = null;

  @override
  void initState() {
    fetchContent();
    super.initState();
  }

  // Methods:
  void fetchContent() async {
    await BackendManager.fetchContentByFilter(widget.category)
        .then((newContent) {
      if (mounted) setState(() => content = newContent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category.displayName),
        ),
        body: content != null
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return ShiurCard(shiur: content![index]);
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: content!.length)
            : const Center(child: CircularProgressIndicator()));
  }
}
