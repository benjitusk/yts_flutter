import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/cards/home_shiur_card.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/recent_shiurim_row_model.dart';
import 'package:yts_flutter/widgets/screens/home_screen.dart';

class RecentShiurimRow extends StatelessWidget {
  const RecentShiurimRow({
    super.key,
    required this.model,
  });

  final RecentShiurimRowModel model;

  @override
  Widget build(BuildContext context) {
    return HomeViewSection(
        title: "Recent Shiurim",
        widget: SizedBox(
            height: 137,
            child: Center(
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    // Space the cards out a bit
                    padding: const EdgeInsets.all(8),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 6),
                    itemCount: model.recentShiurim.length + 1,
                    itemBuilder: (context, index) => index ==
                            model.recentShiurim.length
                        ? _buildLoadMore(context)
                        : HomeShiurCard(shiur: model.recentShiurim[index])))));
  }

  Widget _buildLoadMore(BuildContext context) {
    return Container(
        child: model.isLoadingMore
            ? Container(
                child: const Center(child: const CircularProgressIndicator()),
                margin: const EdgeInsets.symmetric(horizontal: 20),
              )
            :
            // This is the "Load More" button
            IconButton(
                onPressed: () => model.loadMore(10),
                icon: Icon(Icons.chevron_right,
                    size: 50, color: Theme.of(context).primaryColor)));
  }
}
