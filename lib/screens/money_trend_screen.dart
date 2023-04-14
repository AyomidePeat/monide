import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_mechanic/constants/colors.dart';
import 'package:road_mechanic/model/money_trends_model.dart';
import 'package:road_mechanic/services/moneytrends.api.dart';
import 'package:road_mechanic/widgets/money_trend_widget.dart';

final moneyNewsProvider = FutureProvider<List<MoneyTrends>>((ref) async {
  final moneyTrends = ref.watch(moneyApiProvider);
  return moneyTrends.getMoneyTrends();
});

class MoneyTrendsScreen extends ConsumerStatefulWidget {
  const MoneyTrendsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MoneyTrendsScreenState();
}

class _MoneyTrendsScreenState extends ConsumerState<MoneyTrendsScreen> {
  @override
  Widget build(BuildContext context) {
    final moneyTrendsRef = ref.watch(moneyNewsProvider);
    return Scaffold(
        backgroundColor: deepBlue,
        body: RefreshIndicator(
          onRefresh: () => ref.refresh(moneyNewsProvider.future),
          child: moneyTrendsRef.when(data: (data) {
            return ListView.builder(
                itemCount: data.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: MoneyTrendsWidget(
                    title: data[index].title,
                    image: data[index].urlToImage,
                    description: data[index].description,
                    author: data[index].author,
                  ));
                });
          }, error: (error, _) {
            return Text(error.toString());
          }, loading: () {
            return Center(child: const CircularProgressIndicator());
          }),
        ));
  }
}


