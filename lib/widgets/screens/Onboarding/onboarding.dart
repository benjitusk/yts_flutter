import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:yts_flutter/extensions/BuildContext.dart';
import 'package:yts_flutter/utils.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/screens/Onboarding/onboarding_bloc.dart';

class Onboarding extends StatelessWidget {
  final VoidCallback? onFinished;
  final bloc = OnboardingBloc();
  Onboarding({super.key, this.onFinished});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = UI.lightCardGradient.colors[0];
    return OnBoardingSlider(
      totalPage: 5,
      finishButtonText: "Let's go!",
      onFinish: onFinished,
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: backgroundColor,
      ),
      headerBackgroundColor: Colors.white,
      controllerColor: backgroundColor,
      background: _backgroundBuilder([
        ShragaLogo(animated: true, dark: context.isDarkMode),
        Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * 0.8,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                  image: AssetImage('assets/pics/SilvermanShiur.jpg'),
                  fit: BoxFit.contain)),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * 0.8,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                  image: AssetImage('assets/pics/RabbiDavidCrowd.jpg'),
                  fit: BoxFit.contain)),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * 0.8,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                  image: AssetImage('assets/pics/RabbiGoldmanLunch.jpg'),
                  fit: BoxFit.contain)),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * 0.8,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                  image: AssetImage('assets/pics/ShragaFront.jpg'),
                  fit: BoxFit.contain)),
        ),
      ], context),
      speed: 1.8,
      pageBodies: [
        Column(
          children: <Widget>[
            SizedBox(
              height: 580,
            ),
            Text("It's finally here!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 580,
            ),
            Text("The Engaging Shiurim",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    // fontWeight: FontWeight.bold,
                    )),
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 580,
            ),
            Text("The Unforgettable Divrei Torah",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    // fontWeight: FontWeight.bold,
                    )),
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 580,
            ),
            Text("The latest news and updates",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    // fontWeight: FontWeight.bold,
                    )),
            SizedBox(
              height: 10,
            ),
            ListenableBuilder(
                listenable: bloc,
                builder: (context, snapshot) {
                  return ElevatedButton(
                    child: Text(bloc.isNotificationsEnabled
                        ? "Notifications Enabled"
                        : "Enable Notifications"),
                    onPressed: bloc.isNotificationsEnabled
                        ? null
                        : () => bloc.enableNotifications(context),
                  );
                })
          ],
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 500,
            ),
            Text("Everything you missed from Shraga.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    // fontWeight: FontWeight.bold,
                    )),
            SizedBox(
              height: 20,
            ),
            Text("All in one place.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
          ],
        ),
      ],
    );
  }

  List<Widget> _backgroundBuilder(List<Widget> children, BuildContext context) {
    return children
        .map(
          (child) => Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Spacer(),
                child,
                Spacer(),
                Spacer(),
              ],
            ),
          ),
        )
        .toList();
  }
}
