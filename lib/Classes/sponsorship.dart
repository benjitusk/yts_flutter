class Sponsorship {
  String name;
  DateTime dateBegin;
  DateTime dateEnd;
  String? dedication;

  Sponsorship(
      {required this.name,
      required this.dateBegin,
      required this.dateEnd,
      this.dedication});

  static Sponsorship getSponsorshipFromDoc(doc) {
    return Sponsorship(
        name: doc.data()['name'],
        dateBegin: doc.data()['dateBegin'].toDate(),
        dateEnd: doc.data()['dateEnd'].toDate(),
        dedication: doc.data()['dedication']);
  }
}
