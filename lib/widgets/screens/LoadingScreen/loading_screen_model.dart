import 'package:flutter/foundation.dart';
import 'package:yts_flutter/classes/sponsorship.dart';
import 'package:yts_flutter/services/backend_manager.dart';
import 'package:yts_flutter/utils.dart';

const secondsToWait = kDebugMode ? 0 : 5;

class LoadingScreenBloc extends ChangeNotifier {
  final CallbackCallback? _onSponsorshipLoaded;
  Sponsorship? _sponsorship = null;
  Sponsorship? get sponsorship => _sponsorship;
  bool _isLoadingSponsorship = true;
  bool get isLoadingSponsorship => _isLoadingSponsorship;
  bool _isError = false;
  bool get isError => _isError;

  LoadingScreenBloc({
    CallbackCallback? onSponsorshipLoaded,
  }) : _onSponsorshipLoaded = onSponsorshipLoaded {
    print("LoadingScreenBloc created");
    _loadSponsorship()
        .then(
          (loadedSponsorship) {
            print("sponsorship loaded");
            _sponsorship = loadedSponsorship;
            _isLoadingSponsorship = false;
            notifyListeners();
          },
        )
        .then((_) => Future.wait<VoidCallback?>([
              _functionWrapper(_onSponsorshipLoaded)(),
              Future.delayed(Duration(seconds: secondsToWait)).then(
                (_) {
                  return;
                },
              )
              // 5 second timer to ensure that the sponsorship is displayed for at least 5 seconds
            ]))
        .then(
          (promisesResults) {
            promisesResults.forEach((promiseResult) {
              promiseResult?.call();
            });
          },
        );
  }

  Future<Sponsorship?> _loadSponsorship() async {
    return BackendManager.fetchCurrentSponsorship()
        .then((response) => response.result)
        .catchError((_) {
      print("Error loading sponsorship");
      _isError = true;
      notifyListeners();
      return null;
    });
  }

  CallbackCallback _functionWrapper(CallbackCallback? function) {
    return function ??
        () async {
          return () {};
        };
  }
}
