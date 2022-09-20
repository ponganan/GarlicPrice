import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'line_titles.dart';

class PriceChart extends StatelessWidget {
  PriceChart({Key? key}) : super(key: key);

  // final List<Color> gradientColors = [
  //   const Color(0xff23b6ea),
  //   const Color(0xff02d39a),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'กราฟราคากระเทียมจีน',
          //style: TextStyle(color: Colors.blue),
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 5.0,
        ),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 7,
            minY: 0,
            maxY: 80,
            titlesData: LineTitles.getTitleData(),
            gridData: FlGridData(show: true),
            lineBarsData: [
              LineChartBarData(
                  spots: const [
                    FlSpot(0, 49),
                    FlSpot(1, 52),
                    FlSpot(2, 55),
                    FlSpot(3, 48),
                    FlSpot(4, 47),
                    FlSpot(5, 43),
                  ],
                  isCurved: true,
                  color: const Color(0xff02d39a),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xff23b6ea).withOpacity(0.3),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
