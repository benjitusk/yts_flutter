import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yts_flutter/Classes/Shiur.dart';
import 'package:yts_flutter/extensions/Duration.dart';
import 'package:yts_flutter/widgets/helpers/BaseCard.dart';

class ShiurCard extends StatelessWidget {
  const ShiurCard({
    super.key,
    required this.shiur,
  });

  final Shiur shiur;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
            // border: Border.all(color: Theme.of(context).colorScheme.secondary)
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 7,
              )
            ]),
        child: BaseCard(
          // constraints: BoxConstraints(minHeight: 125),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF182030),
                              Color(0xFF4A5B82),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.mic,
                          size: 35,
                          color: Theme.of(context).colorScheme.secondary,
                        ))),
                Flexible(
                    flex: 3,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Text(shiur.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 8),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  SizedBox(width: 5),
                                  Text(shiur.author.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.grey)),
                                ],
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      SizedBox(width: 5),
                                      Text(
                                          DateFormat.yMMMd().format(shiur.date),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: Colors.grey)),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      SizedBox(width: 5),
                                      Text(
                                          shiur.duration
                                              .toHoursMinutesSeconds(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
