import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/sponsorship.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class LoadingScreenModel with ChangeNotifier {
  bool _isLoadingSponsorship = false;
  Sponsorship? _sponsorship = null;

  bool get isLoadingSponsorship => _isLoadingSponsorship;
  Sponsorship? get sponsorship => _sponsorship;

  LoadingScreenModel() {
    loadSponsorship();
  }

  void setLoadingSponsorship(bool value) {
    _isLoadingSponsorship = value;
    notifyListeners();
  }

  void setSponsorship(Sponsorship? value) {
    _sponsorship = value;
    _isLoadingSponsorship = false;
    notifyListeners();
  }

  void loadSponsorship() async {
    setLoadingSponsorship(true);
    // First see if we can get anything from the cache
    Sponsorship? cachedSponsorship =
        await Sponsorship.getSponsorshipFromCache();
    if (!(cachedSponsorship?.isActive ?? false)) {
      cachedSponsorship = null;
    }
    setSponsorship(cachedSponsorship);
    setLoadingSponsorship(false);
    // If not, get it from the database, and save it to the cache if it exists
    Sponsorship? newSponsor = await BackendManager.fetchCurrentSponsorship()
        .then((response) => response.result);
    Sponsorship.saveToCache(newSponsor);
  }
}
