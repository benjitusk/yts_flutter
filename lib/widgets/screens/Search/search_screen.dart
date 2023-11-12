import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/widgets/screens/Search/search_screen_model.dart';

class ContentSearch extends SearchDelegate<(Shiur?, Author?)?> {
  final ContentSearchModel model = ContentSearchModel();
  final List<Shiur> shiurim;
  final List<Author> rebbeim;

  ContentSearch({
    // required this.newsArticles,
    required this.shiurim,
    required this.rebbeim,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // This function gets called when the user submits a search query
    query = query.trim();
    if (query.isEmpty) {
      return const Text("Search for shiurim, rebbeim, etc.");
    }

    return FutureBuilder(
        future: model.search(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }
          final List<Shiur> shiurimResults = snapshot.data!.$1;
          final List<Author> rebbeimResults = snapshot.data!.$2;
          if (shiurimResults.isEmpty && rebbeimResults.isEmpty)
            return Center(
              child: Text("No results found.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5))),
            );
          return ListView.builder(
            itemCount: shiurimResults.length + rebbeimResults.length,
            itemBuilder: (context, index) {
              if (index < rebbeimResults.length) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(rebbeimResults[index].name),
                  onTap: () {
                    close(context, (null, rebbeimResults[index]));
                  },
                );
              } else {
                return ListTile(
                    leading: const Icon(Icons.mic),
                    title: Text(
                        shiurimResults[index - rebbeimResults.length].title),
                    onTap: () => close(context,
                        (shiurimResults[index - rebbeimResults.length], null)));
              }
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This function is called when the user types in the search bar (live search)
    // The results displayed here will be pulled from only currently loaded content
    // As in, content that happens to be loaded in the HomeScreen (shiurim, rebbeim, etc.)
    print("buildSuggestions called: $query");
    if (query.isEmpty) {
      if (model.searchHistory.isEmpty) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Search for shiurim, rebbeim, etc.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.5))),
        ));
      }
      final List<String> searchHistory = model.searchHistory.reversed.toList();
      return ListView.builder(
        itemCount: searchHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(searchHistory[index]),
            onTap: () {
              query = searchHistory[index];
              showResults(context);
            },
          );
        },
      );
    }

    List<Shiur> shiurResults = [];
    List<Author> rabbiResults = [];

    for (Shiur shiur in shiurim) {
      if (shiur.title.toLowerCase().contains(query.toLowerCase())) {
        shiurResults.add(shiur);
      }
    }

    for (Author rabbi in rebbeim) {
      if (rabbi.name.toLowerCase().contains(query.toLowerCase())) {
        rabbiResults.add(rabbi);
      }
    }

    return ListView.builder(
      itemCount: shiurResults.length + rabbiResults.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            leading: const Icon(Icons.search),
            title: Text(query),
            onTap: () => showResults(context),
          );
        }
        index -= 1;
        if (index < shiurResults.length) {
          return ListTile(
            leading: const Icon(Icons.mic),
            title: _buildSearchResultFrom(
                query: query, match: shiurResults[index].title),
            onTap: () {
              close(context, (shiurResults[index], null));
            },
          );
        } else {
          return ListTile(
            leading: const Icon(Icons.person),
            title: _buildSearchResultFrom(
                query: query,
                match: rabbiResults[index - shiurResults.length].name),
            onTap: () {
              close(context, (null, rabbiResults[index - shiurResults.length]));
            },
          );
        }
      },
    );
  }

  Text _buildSearchResultFrom({required String query, required String match}) {
    return Text.rich(
      TextSpan(
        text: match.substring(
            0, match.toLowerCase().indexOf(query.toLowerCase())),
        // style: const TextStyle(color: Colors.grey),
        children: [
          TextSpan(
            text: match.substring(
                match.toLowerCase().indexOf(query.toLowerCase()),
                match.toLowerCase().indexOf(query.toLowerCase()) +
                    query.length),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: match.substring(
                match.toLowerCase().indexOf(query.toLowerCase()) + query.length,
                match.length),
            // style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
