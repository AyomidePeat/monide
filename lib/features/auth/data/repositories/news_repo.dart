import '../entities/money_trends.dart';

abstract class NewsRepository {
  Future<List<MoneyTrends>> getMoneyTrends();
}