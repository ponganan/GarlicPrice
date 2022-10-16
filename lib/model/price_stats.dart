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
        dateTime: snap['datetime'].toDate(),
        index: index,
        price: snap['price']);
  }
}
