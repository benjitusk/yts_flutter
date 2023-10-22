import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/sponsorship.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class LoadingScreenBloc extends ChangeNotifier {
  final VoidCallback? _onSponsorshipLoaded;

  Sponsorship? _sponsorship = null;
  Sponsorship? get sponsorship => _sponsorship;
  bool _isLoadingSponsorship = true;
  bool get isLoadingSponsorship => _isLoadingSponsorship;

  LoadingScreenBloc({VoidCallback? onSponsorshipLoaded})
      : _onSponsorshipLoaded = onSponsorshipLoaded {
    _loadSponsorship().then((loadedSponsorship) {
      _sponsorship = loadedSponsorship;
      _isLoadingSponsorship = false;
      notifyListeners();
      _onSponsorshipLoaded?.call();
    });
  }

  Future<Sponsorship?> _loadSponsorship() async {
    return BackendManager.fetchCurrentSponsorship()
        .then((response) => response.result);
  }
}
