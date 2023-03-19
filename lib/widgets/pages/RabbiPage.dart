import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/Classes/Author.dart';
import 'package:yts_flutter/Classes/Shiur.dart';

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
    }).then((newContent) => setState(() => content.addAll(newContent)));
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
        body: ListView.builder(
          itemBuilder: ((context, index) {
            return Text(content[index].title);
          }),
          itemCount: content.length,
        ));
  }
}
