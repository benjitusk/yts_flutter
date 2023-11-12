import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/widgets/screens/Settings/Upload/upload_screen_bloc.dart';

class UploadShiurScreen extends StatelessWidget {
  UploadShiurScreen({super.key});
  final UploadScreenBloc bloc = UploadScreenBloc();
  final list = [
    "Rabbi",
    "Category",
    "Rosh Yeshiva",
    "Rosh Kollel",
    "Mashgiach",
    "Maggid Shiur",
    "Maggid Shiur",
  ];
  @override
  Widget build(BuildContext context) {
    print("=====  [ RABBI LIST ]  =====]");
    bloc.rebbeim.forEach((element) {
      print(element.name);
    });
    return Container(
        // decoration: BoxDecoration(border: Border.all(color: Colors.amber)),
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Shiur title',
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 5,
                  child: ListenableBuilder(
                      listenable: bloc,
                      builder: (context, _) {
                        return Container(
                            child: DropdownButton<Author>(
                          value: bloc.selectedRabbi,
                          hint: const Text("Rabbi"),
                          onChanged: bloc.selectRabbi,
                          items: bloc.rebbeim
                              .map<DropdownMenuItem<Author>>((Author value) {
                            return DropdownMenuItem<Author>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ));
                      }),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: ListenableBuilder(
                      listenable: bloc,
                      builder: (context, _) {
                        return Container(
                            child: DropdownButton<Category>(
                          value: bloc.selectedCategory,
                          hint: const Text("Category"),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: bloc.selectCategory,
                          items: bloc.categories
                              .expand<Category>((element) =>
                                  [element, ...(element.children ?? [])])
                              .where((element) =>
                                  element.children?.isEmpty ?? true)
                              .sorted((a, b) =>
                                  a.displayName.compareTo(b.displayName))
                              .toList()
                              .map<DropdownMenuItem<Category>>((value) {
                            return DropdownMenuItem<Category>(
                              value: value,
                              child: Text(value.displayName),
                            );
                          }).toList(),
                        ));
                      }),
                ),
              ],
            ),
            Spacer(),
            Container(
              // decoration: BoxDecoration(
              // border: Border.all(color: Theme.of(context).dividerColor)),
              child: Column(
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: Icon(Icons.mic),
                    label: Text("Record live audio"),
                    onPressed: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(children: <Widget>[
                      Expanded(child: Divider()),
                      Text("OR"),
                      Expanded(child: Divider()),
                    ]),
                  ),
                  ElevatedButton.icon(
                      icon: Icon(Icons.upload_file),
                      label: Text("Upload a file",
                          style: TextStyle(fontStyle: FontStyle.italic)),
                      onPressed: () {}),
                ],
              ),
            ),
            // Spacer(),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text("Submit"),
            ),
            // Spacer(),
            Spacer()
          ],
        ));
  }
}
