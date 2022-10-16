import 'package:flutter/material.dart';
import 'package:garlic_price/controllers/price_stats_controller.dart';
import 'package:garlic_price/model/price_stats.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PriceChartPage extends StatefulWidget {
  PriceChartPage({Key? key}) : super(key: key);

  @override
  State<PriceChartPage> createState() => _PriceChartPageState();
}

class _PriceChartPageState extends State<PriceChartPage> {
  final PriceStatsController priceStatsController =
      Get.put(PriceStatsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'กราฟราคากระเทียม',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          FutureBuilder(
            future: priceStatsController.stats.value,
            builder: (BuildContext context,
                AsyncSnapshot<List<PriceStats>> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: SizedBox(
                    height: 500,
                    child: CustomBarChart(
                      priceStats: snapshot.data!,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            },

            //
          ),
        ],
      ),
    );
  }
}

class CustomBarChart extends StatefulWidget {
  const CustomBarChart({
    Key? key,
    required this.priceStats,
  }) : super(key: key);

  final List<PriceStats> priceStats;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<PriceStats, String>> series = [
      charts.Series(
        id: 'price',
        data: widget.priceStats,
        domainFn: (series, _) =>
            DateFormat.d().format(series.dateTime).toString(),
        measureFn: (series, _) => series.price,
        colorFn: (series, _) => series.barColor!,
      )
    ];
    return charts.BarChart(
      series,
      animate: true,
    );
  }
}
