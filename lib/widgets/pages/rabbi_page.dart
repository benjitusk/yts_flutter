import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/widgets/cards/standard_shiur_card.dart';
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
    FirebaseFirestore.instance
        .collection("content")
        .where("attributionID", isEqualTo: widget.rabbi.id)
        .orderBy("date", descending: true)
        .limit(10)
        .get()
        .then((querySnapshot) {
      return Future.wait(querySnapshot.docs.map((doc) async {
        return await Shiur.fromJson(doc.data(), author: widget.rabbi);
      }));
    }).then((newContent) {
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
          // padding: const EdgeInsets.only(
          //     left: UI.PAGE_PADDING,
          //     right: UI.PAGE_PADDING,
          //     top: UI.PAGE_PADDING),
          child: Column(
            children: [
              // SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (ctx, i) =>
                      SizedBox(height: (i > 0) ? 8 : 0),
                  itemBuilder: ((context, index) {
                    if (index == 0)
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextDivider("Recents"),
                      );
                    final shiur = content[index - 1];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: ShiurCard(shiur: shiur),
                    );
                  }),
                  itemCount: content.length + 1,
                ),
              ),
            ],
          ),
        ));
  }
}
