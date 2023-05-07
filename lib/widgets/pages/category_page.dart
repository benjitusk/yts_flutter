import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/classes/misc_types.dart';
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
  LoadingState loadingState = LoadingState.loading;
  dynamic error = null;
  List<Shiur>? content = null;
  List<Category>? subCategories = null;

  @override
  void initState() {
    fetchContent();
    super.initState();
  }

  // Methods:

  void _updateLoadingState() {
    if (error != null) {
      setState(() => loadingState = LoadingState.error);
    } else if (content == null || subCategories == null) {
      setState(() => loadingState = LoadingState.loading);
    } else if (content!.isEmpty && subCategories!.isEmpty) {
      setState(() => loadingState = LoadingState.empty);
    } else {
      setState(() => loadingState = LoadingState.done);
    }
  }

  void fetchContent() async {
    _updateLoadingState();
    if (widget.category.isParent) {
      subCategories ??= [];
      widget.category.children?.forEach((childCategoryID) async {
        await BackendManager.fetchCategoryByID(childCategoryID)
            .then((newCategory) {
          if (mounted)
            setState(() => subCategories!
              ..add(newCategory)
              ..sort((a, b) => a.displayName.compareTo(b.displayName)));
        }).catchError((error) {
          print(error);
          this.error = error;
          throw error;
        }).whenComplete(() => _updateLoadingState());
      });
    } else {
      subCategories = [];
      _updateLoadingState();
    }
    await BackendManager.fetchContentByFilter(widget.category,
            sortByRecent: true)
        .then((newContent) {
      if (mounted) setState(() => content = newContent);
    }).catchError((error) {
      print(error);
      this.error = error;
      throw error;
    }).whenComplete(() => _updateLoadingState());
  }

  @override
  Widget build(BuildContext context) {
    final numberOfSubCategories = subCategories?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.displayName),
      ),
      body: (() {
        switch (loadingState) {
          case LoadingState.loading:
            return const Center(child: CircularProgressIndicator());
          case LoadingState.empty:
            return const Center(child: Text('No content found.'));
          case LoadingState.error:
            return Center(
                child: Text('Error: ${error.toString()}. Please try again.'));
          case LoadingState.done:
            return ListView.separated(
                itemBuilder: (context, index) {
                  if (index < numberOfSubCategories) {
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
                  return ContentDataTable(shiur: content![index]);
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: numberOfSubCategories + content!.length);
        }
      })(),

      // If content or subcategories is null, we are still loading.
      // If content and subcategories is empty, we are done loading, but there is no content.
      // If content or subcategories is not empty, we are done loading, and there is content.
      //     (loadingState == LoadingState.loading)
      // ? const Center(child: CircularProgressIndicator())
      // : (loadingState == LoadingState.empty)

      //     tODO: show a nice message
      //     ? const Center(child: Text('No content found.'))
      //     : ListView.separated(
      //         itemBuilder: (context, index) {
      //           if (subCategories != null &&
      //               index < numberOfSubCategories) {
      //             return ListTile(
      //               leading: Icon(Icons.folder),
      //               title: Text(subCategories![index].displayName),
      //               onTap: () => Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => CategoryPage(
      //                           category: subCategories![index]))),
      //             );
      //           }
      //           if (content != null)
      //             return ContentDataTable(
      //                 shiur: content![index - numberOfSubCategories]);

      //           return const Center(child: CircularProgressIndicator());
      //         },
      //         separatorBuilder: (context, index) => const Divider(
      //               height: 1,
      //             ),
      //         itemCount: (content?.length ?? 0) + numberOfSubCategories)
    );
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
