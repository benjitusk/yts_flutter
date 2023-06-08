import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/widgets/content_table_row.dart';
import 'package:yts_flutter/widgets/helpers/TextDivider.dart';
import 'package:yts_flutter/widgets/pages/rabbi_page_model.dart';

class RabbiPage extends StatelessWidget {
  RabbiPage({super.key, required Author rabbi}) {
    this.model = RabbiPageModel(rabbi: rabbi);
    this.model.initialLoad();
  }
  late final RabbiPageModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(model.rabbi.name),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                minRadius: 25,
                backgroundImage:
                    CachedNetworkImageProvider(model.rabbi.profilePictureURL),
              ),
            )
          ],
        ),
        body: ListenableBuilder(
            listenable: model,
            builder: (context, _) {
              if (model.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (model.content.isEmpty)
                return const Center(child: Text('No content found.'));
              return Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: ((context, index) {
                          if (index == 0)
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextDivider("Recents"),
                            );
                          if (index == model.content.length + 1) {
                            if (model.isLoadingMore) {
                              return Center(
                                  child: Container(
                                      margin: const EdgeInsets.all(8),
                                      child: CircularProgressIndicator()));
                            }
                            if (model.hasMore) {
                              return ElevatedButton(
                                  onPressed: () => model.loadMore(),
                                  child: const Text('Load more'));
                              // model.loadMore(30);
                              // return const Center(
                              //     child: CircularProgressIndicator());
                            }
                            // return const SizedBox();
                          }
                          final shiur = model.content[index - 1];
                          return ContentTableRow(
                              shiur: shiur, showAuthor: false);
                        }),
                        itemCount:
                            model.content.length + (model.hasMore ? 2 : 1),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
