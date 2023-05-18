import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:yts_flutter/classes/news_article.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/helpers/markdown_helper.dart';
import 'package:yts_flutter/widgets/pages/article_page.dart';

const double _iconPadding = 3;
const double _outerBorderRadius = 8.0;
const double _innerBorderRadiusRatio = 6.9 / 8.0;

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_outerBorderRadius),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          )),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(_innerBorderRadiusRatio * _outerBorderRadius),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  child: Text(article.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  decoration: BoxDecoration(
                      gradient: UI.getCardGradient(using: context)),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  child: CustomMarkdownBody(
                    data: article.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    styleSheet: MarkdownStyleSheet(
                        a: TextStyle(
                            // Don't make links look clickable
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color)),
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: _iconPadding),
                            child: Icon(Icons.person,
                                size: 16,
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary),
                          ),
                          Text(article.author),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: _iconPadding),
                            child: Icon(Icons.calendar_month,
                                size: 16,
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary),
                          ),
                          Text(
                              DateFormat.yMMMd().format(article.date.toDate())),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned.fill(
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArticlePage(
                                    article: article,
                                  )));
                    }))),
          ],
        ),
      ),
    );
  }
}
