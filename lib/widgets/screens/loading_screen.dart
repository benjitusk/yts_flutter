import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/screens/loading_screen_model.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final themeSensitiveIcon = isDarkTheme
        ? const AssetImage('assets/Shraga_white.png')
        : const AssetImage('assets/Shraga_black.png');

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(children: [
          Spacer(),
          Spacer(),
          Image(
            image: themeSensitiveIcon,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          Text(
            'Loading...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SponsorshipPlaque(),
          Spacer(),
        ]),
      ),
    );
  }
}

class SponsorshipPlaque extends StatelessWidget {
  SponsorshipPlaque({super.key});
  final LoadingScreenModel model = LoadingScreenModel();

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.all(30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(10),
          constraints: BoxConstraints(minWidth: 200, minHeight: 100),
          decoration: BoxDecoration(
              gradient:
                  isDarkTheme ? UI.darkCardGradient : UI.lightCardGradient),
          child: IntrinsicWidth(
            child: ListenableBuilder(
                listenable: model,
                builder: (context, _) {
                  if (model.isLoadingSponsorship || model.sponsorship == null)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      Text(
                          "Learning for the month of Sivan is sponsored by ${model.sponsorship?.name}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white)),
                      SizedBox(height: 10),
                      if (model.sponsorship!.dedication != null)
                        Text(model.sponsorship!.dedication!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white)),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
