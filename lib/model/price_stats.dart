import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PriceStats {
  final DateTime dateTime;
  final int index;
  final int price;
  charts.Color? barColor;

  PriceStats(
      {required this.dateTime, required this.index, required this.price}) {
    barColor = charts.ColorUtil.fromDartColor(Colors.blue);
  }

  factory PriceStats.fromSnapshot(DocumentSnapshot snap, int index) {
    return PriceStats(
        dateTime: snap['datetime'].toDate, index: index, price: snap['price']);
  }

  static final List<PriceStats> data = [
    PriceStats(dateTime: DateTime.now(), index: 0, price: 38),
    PriceStats(dateTime: DateTime.now(), index: 1, price: 20),
    PriceStats(dateTime: DateTime.now(), index: 2, price: 33),
    PriceStats(dateTime: DateTime.now(), index: 3, price: 56),
    PriceStats(dateTime: DateTime.now(), index: 4, price: 49),
    PriceStats(dateTime: DateTime.now(), index: 5, price: 42),
    PriceStats(dateTime: DateTime.now(), index: 6, price: 50),
    PriceStats(dateTime: DateTime.now(), index: 7, price: 51),
    PriceStats(dateTime: DateTime.now(), index: 8, price: 47),
    PriceStats(dateTime: DateTime.now(), index: 9, price: 45),
  ];
}
