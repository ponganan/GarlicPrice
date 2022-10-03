import 'package:garlic_price/model/price_stats.dart';
import 'package:garlic_price/services/database_service.dart';
import 'package:get/get.dart';

class PriceStatsController extends GetxController {
  final DatabaseService database = DatabaseService();

  var stats = Future.value(<PriceStats>[]).obs;

  @override
  void onInit() {
    stats.value = database.getPriceStats();
    super.onInit();
  }
}
