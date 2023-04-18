import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_mechanic/constants/colors.dart';
import 'package:road_mechanic/model/money_trends_model.dart';
import 'package:road_mechanic/services/moneytrends.api.dart';
import 'package:road_mechanic/widgets/money_trend_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final moneyTrendsRef = ref.watch(moneyNewsProvider);
    return Scaffold(
        backgroundColor: deepBlue,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Row(
              children: [IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
                const Text(
                  'Money Trends for You',
                  style: TextStyle(
                      color: Colors.white,  fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            )),
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
                      image: data[index].image,
                      description: data[index].description,
                      source: data[index].source,
                    ),
                    onTap: () {
                      
                      String newsUrl = data[index].url;
                      _launchURL(newsUrl);
                    },
                  );
                });
          }, error: (error, _) {
            return Text(error.toString());
          }, loading: () {
            return const Center(child: CircularProgressIndicator());
          }),
        ));
  }
}
