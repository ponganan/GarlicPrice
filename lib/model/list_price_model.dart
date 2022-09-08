import 'package:cloud_firestore/cloud_firestore.dart';

class ListPriceModel {
  final int price;
  final DateTime dateTime;

  ListPriceModel({
    required this.price,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'price': price,
        'datetime': dateTime,
      };

  static ListPriceModel fromJson(Map<String, dynamic> json) => ListPriceModel(
        price: json['price'],
        dateTime: (json['datetime'] as Timestamp).toDate(),
      );
}
