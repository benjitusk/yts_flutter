import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yts_flutter/classes/misc_types.dart';

class Sponsorship {
  String name;
  DateTime dateBegin;
  DateTime dateEnd;
  String? dedication;
  FirebaseID id;
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(dateBegin) && now.isBefore(dateEnd);
  }

  Sponsorship(
      {required this.id,
      required this.name,
      required this.dateBegin,
      required this.dateEnd,
      this.dedication});

  static Sponsorship getSponsorshipFromDoc(QueryDocumentSnapshot<dynamic> doc) {
    return Sponsorship(
        id: doc.id,
        name: doc.data()['name'],
        dateBegin: doc.data()['dateBegin'].toDate(),
        dateEnd: doc.data()['dateEnd'].toDate(),
        dedication: doc.data()['dedication']);
  }

  static Future<Sponsorship?> getSponsorshipFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('sponsorship.id');
    final name = prefs.getString('sponsorship.name');
    final dateBegin = prefs.getInt('sponsorship.dateBegin');
    final dateEnd = prefs.getInt('sponsorship.dateEnd');
    String? dedication = prefs.getString('sponsorship.dedication');
    if (dedication == '') dedication = null;
    if (name == null || dateBegin == null || dateEnd == null || id == null) {
      return null;
    }

    return Sponsorship(
        id: id,
        name: name,
        dateBegin: DateTime.fromMillisecondsSinceEpoch(dateBegin),
        dateEnd: DateTime.fromMillisecondsSinceEpoch(dateEnd),
        dedication: dedication);
  }

  static void saveToCache(Sponsorship? sp) async {
    final prefs = await SharedPreferences.getInstance();
    if (sp == null) {
      prefs.remove('sponsorship.id');
      prefs.remove('sponsorship.name');
      prefs.remove('sponsorship.dateBegin');
      prefs.remove('sponsorship.dateEnd');
      prefs.remove('sponsorship.dedication');
      return;
    }
    prefs.setString('sponsorship.id', sp.id);
    prefs.setString('sponsorship.name', sp.name);
    prefs.setInt('sponsorship.dateBegin', sp.dateBegin.millisecondsSinceEpoch);
    prefs.setInt('sponsorship.dateEnd', sp.dateEnd.millisecondsSinceEpoch);
    prefs.setString('sponsorship.dedication', sp.dedication ?? '');
  }
}
