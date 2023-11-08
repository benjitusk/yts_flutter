import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/cards/news_card.dart';
import 'package:yts_flutter/widgets/screens/news_screen_modal.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({super.key});
  final NewsScreenModal model = NewsScreenModal();
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: model.articles.length < 0
                ? ListView.separated(
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: index == 0
                              ? EdgeInsets.only(top: 16)
                              : EdgeInsets.zero,
                          child: NewsCard(article: model.articles[index]));
                    },
                    itemCount: model.articles.length,
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      );
                    },
                  )
                : // Centered disabled text saying that there are no articles
                Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No articles at this time.',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.5)),
                        ),
                        Text(
                          'Please check back later.',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
