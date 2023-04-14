import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/extensions/Duration.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.category});
  final Category category;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // State variables:
  List<Shiur>? content = null;
  List<Category>? subCategories = null;

  @override
  void initState() {
    fetchContent();
    super.initState();
  }

  // Methods:
  void fetchContent() async {
    if (widget.category.isParent) {
      subCategories = [];
      widget.category.children?.forEach((childCategoryID) async {
        await BackendManager.fetchCategoryByID(childCategoryID)
            .then((newCategory) {
          if (mounted)
            setState(() => subCategories!
              ..add(newCategory)
              ..sort((a, b) => a.displayName.compareTo(b.displayName)));
        });
      });
    }
    await BackendManager.fetchContentByFilter(widget.category,
            sortByRecent: true)
        .then((newContent) {
      if (mounted) setState(() => content = newContent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final numberOfSubCategories = subCategories?.length ?? 0;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category.displayName),
        ),
        body: ((content?.isNotEmpty ?? false) ||
                (subCategories?.isNotEmpty ?? false))
            ? ListView.separated(
                itemBuilder: (context, index) {
                  if (subCategories != null && index < numberOfSubCategories) {
                    return ListTile(
                      leading: Icon(Icons.folder),
                      title: Text(subCategories![index].displayName),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                  category: subCategories![index]))),
                    );
                  }
                  if (content != null)
                    return ContentDataTable(
                        shiur: content![index - numberOfSubCategories]);

                  return const Center(child: CircularProgressIndicator());
                },
                separatorBuilder: (context, index) => const Divider(
                      height: 1,
                    ),
                itemCount: (content?.length ?? 0) + numberOfSubCategories)
            :
            // We checked, and there is no content in this category.
            /// TODO: Show a nice message.
            const Center(child: Text('No content in this category')));
  }
}

class ContentDataTable extends StatelessWidget {
  const ContentDataTable({super.key, required this.shiur});
  final _imageSize = 50.0;
  final Shiur shiur;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: (shiur.author is Author)
            ? CachedNetworkImage(
                imageUrl: (shiur.author as Author).profilePictureURL,
                imageBuilder: (context, imageProvider) => Container(
                  width: _imageSize,
                  height: _imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : const Icon(Icons.mic),
        title: Text(shiur.title),
        subtitle: Text(
          DateFormat.yMMMd().format(shiur.date),
        ),
        // isThreeLine: true,

        trailing: Text(shiur.duration.toHoursMinutesSeconds()),
        onTap: () => null);
  }
}
