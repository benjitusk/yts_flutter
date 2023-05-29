import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/sponsorship.dart';
import 'package:yts_flutter/services/backend_manager.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Sponsorship? sponsorship;

  @override
  void initState() {
    super.initState();
    BackendManager.fetchCurrentSponsorship().then((value) {
      setState(() {
        sponsorship = value;
      });
    });
  }

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
          if (sponsorship != null) SponsorshipPlaque(sponsorship: sponsorship!),
          Spacer(),
        ]),
      ),
    );
  }
}

class SponsorshipPlaque extends StatelessWidget {
  const SponsorshipPlaque({super.key, required this.sponsorship});
  final Sponsorship sponsorship;

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
                Text(
                    "Learning for the month of Sivan is sponsored by ${sponsorship.name}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white)),
                SizedBox(height: 10),
                if (sponsorship.dedication != null)
                  Text(sponsorship.dedication!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
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
