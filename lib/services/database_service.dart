import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garlic_price/model/price_stats.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<PriceStats>> getPriceStats() {
    return _firebaseFirestore
        .collection('price')
        .orderBy('datetime')
        .limitToLast(10)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .asMap()
            .entries
            .map((entry) => PriceStats.fromSnapshot(entry.value, entry.key))
            .toList());
  }
}
