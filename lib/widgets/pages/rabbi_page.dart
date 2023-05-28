import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/services/backend_manager.dart';
import 'package:yts_flutter/widgets/content_table_row.dart';
import 'package:yts_flutter/widgets/helpers/TextDivider.dart';

class RabbiPage extends StatefulWidget {
  const RabbiPage({super.key, required this.rabbi});
  final Author rabbi;

  @override
  State<RabbiPage> createState() => _RabbiPageState();
}

class _RabbiPageState extends State<RabbiPage> {
  final List<Shiur> content = [];

  void fetchContent() {
    BackendManager.fetchContentByFilter(widget.rabbi).then((newContent) {
      if (mounted) setState(() => content.addAll(newContent));
    });
  }

  @override
  void initState() {
    fetchContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.rabbi.name),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                minRadius: 25,
                backgroundImage:
                    CachedNetworkImageProvider(widget.rabbi.profilePictureURL),
              ),
            )
          ],
        ),
        body: Padding(
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
                    final shiur = content[index - 1];
                    return ContentTableRow(shiur: shiur, showAuthor: false);
                  }),
                  itemCount: content.length + 1,
                ),
              ),
            ],
          ),
        ));
  }
}
