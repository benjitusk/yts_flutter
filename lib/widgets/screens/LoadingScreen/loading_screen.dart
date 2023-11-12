import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/sponsorship.dart';
import 'package:yts_flutter/utils.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/screens/LoadingScreen/loading_screen_model.dart';

class LoadingScreen extends StatelessWidget {
  final CallbackCallback? onSponsorhipLoaded;
  final LoadingScreenBloc bloc;
  LoadingScreen({super.key, this.onSponsorhipLoaded})
      : bloc = LoadingScreenBloc(onSponsorshipLoaded: onSponsorhipLoaded);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(children: [
          Spacer(),
          Spacer(),
          ShragaLogo(dark: isDarkTheme(context), animated: true),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListenableBuilder(
                listenable: bloc,
                builder: (context, _) {
                  return Visibility(
                    child: CircularProgressIndicator(),
                    visible: !bloc.isError,
                  );
                }),
          ),
          ListenableBuilder(
            listenable: bloc,
            builder: (context, _) {
              // We want to show the SPONSOR button only if we've loaded the sponsorship and found that it's expired
              // otherwise, if the sponsorship is null or not expired, we don't want to show the button. also, if we're
              // still loading the sponsorship, we don't want to show the button.
              // Show the plaque conditionally:
              if (bloc.isError)
                return ErrorPlaque();
              else if ((bloc.sponsorship != null &&
                      bloc.sponsorship!.isActive) ||
                  bloc.isLoadingSponsorship)
                return Visibility(
                  child: SponsorshipPlaque(bloc.sponsorship),
                  visible: bloc.sponsorship != null &&
                      bloc.sponsorship!.isActive &&
                      !bloc.isLoadingSponsorship,
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                );
              else
                return SponsorshipPrompt();
            },
          ),
          Spacer(),
        ]),
      ),
    );
  }
}

class SponsorshipPrompt extends StatelessWidget {
  const SponsorshipPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
        margin: EdgeInsets.all(30),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
                padding: EdgeInsets.all(18),
                constraints: BoxConstraints(minWidth: 200, minHeight: 100),
                decoration: BoxDecoration(
                    gradient: isDarkTheme
                        ? UI.darkCardGradient
                        : UI.lightCardGradient),
                child: Column(
                  children: [
                    Text("Keep the flame of Torat Shraga burning!",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white)),
                    SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: onSponsorshipPromptClick,
                        child: Text("Sponsor the app"))
                  ],
                ))));
  }
}

class SponsorshipPlaque extends StatelessWidget {
  final Sponsorship? sponsorship;
  SponsorshipPlaque(this.sponsorship);

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Text(sponsorship?.title ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white)),
                SizedBox(height: 10),
                Visibility(
                  child: Text(sponsorship?.dedication ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white)),
                  visible: sponsorship?.dedication != null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorPlaque extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.all(30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(16),
          constraints: BoxConstraints(minWidth: 200, minHeight: 100),
          decoration: BoxDecoration(
              gradient: isDarkTheme
                  ? UI.darkErrorCardGradient
                  : UI.lightErrorCardGradient),
          child: IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Text("Something went wrong.",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                    "We can't reach the server. Check your internet connection, or try again later.",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white)),
                SizedBox(height: 10),
                Text(
                    "Here's an randomly generated error code: 0x${Random().nextInt(100000).toRadixString(16).toUpperCase()}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
