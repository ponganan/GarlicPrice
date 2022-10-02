import 'package:cloud_firestore/cloud_firestore.dart';

class ListPriceChart {
  final int price;

  ListPriceChart({
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'price': price,
      };

  static ListPriceChart fromJson(Map<String, dynamic> json) => ListPriceChart(
        price: json['price'],
      );

  buildPrice(ListPriceChart price) => int(
        '${price.price}',
      );

  Stream<List<ListPriceChart>> readPrice() => FirebaseFirestore.instance
      .collection('price')
      //sort datetime
      .orderBy('datetime', descending: true)
      .limit(6)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ListPriceChart.fromJson(doc.data()))
          .toList());
}
