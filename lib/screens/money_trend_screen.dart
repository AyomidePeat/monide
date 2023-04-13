import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_mechanic/constants/colors.dart';
import 'package:road_mechanic/model/money_trends_model.dart';
import 'package:road_mechanic/services/moneytrends.api.dart';
import 'package:road_mechanic/widgets/money_trend_widget.dart';

final musicNewsProvider = FutureProvider<List<MoneyTrends>>((ref) async {
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
    final moneyTrendsRef = ref.watch(musicNewsProvider);
    return Scaffold(
        backgroundColor: deepBlue,
        body: RefreshIndicator(
          onRefresh: () => ref.refresh(musicNewsProvider.future),
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



// class MoneyTrendsScreen extends ConsumerStatefulWidget {
//   const MoneyTrendsScreen({super.key});

//   @override
//   State<MoneyTrendsScreen> createState() => _MoneyTrendsScreenState();
// }

// class _MoneyTrendsScreenState extends State<MoneyTrendsScreen> {
//   List<MoneyTrends> moneyTrends = [];
//   bool isLoading = true;
//   String errorMessage = '';
//   final moneyTrendsApi = MoneyTrendsApi();
//   @override
//   void initState() {
//     getTrends();
//   }

//   Future<void> getTrends() async {
//     try {
//       final moneyTrend = await moneyTrendsApi.getMoneyTrends();
//       setState(() {
//         if (moneyTrend.isNotEmpty) {
//           moneyTrends = moneyTrend;
//           isLoading = false;
//         } else {
//           errorMessage = 'No data found';
//           isLoading = false;
//         }
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = e.toString();
//         print(errorMessage);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final moneyTrendsRef = ref.watch(musicNewsProvider);
//     return Scaffold(
//         backgroundColor: deepBlue,
//         body: RefreshIndicator(
//           onRefresh: ()=> ref.refresh(musicNewsProvider.future),
//           child: moneyTrendsRef.when(data: (data) {
//             return ListView.builder(
//                 itemCount: data.length,
//                 physics: const BouncingScrollPhysics(),
//                 itemBuilder: (BuildContext context, int index) {
//                   return ListTile(
//                       title: MoneyTrendsWidget(
//                     title: data[index].title,
//                     image: data[index].urlToImage,
//                     description: data[index].description,
//                     author: data[index].author,
//                   ));
//                 });
//           }, error: (error, _) {
//             return Text(error.toString());
//           }, loading: () {
//             return const CircularProgressIndicator();
//           }),
//         )
//         // isLoading
//         //     ? const Center(child: CircularProgressIndicator())
//         //     : errorMessage.isNotEmpty
//         //         ? Center(
//         //             child:
//         //                 Text(errorMessage, style: TextStyle(color: Colors.red)))
//         //         : ListView.builder(
//         //             itemCount: moneyTrends.length,
//         //             physics: BouncingScrollPhysics(),
//         //             itemBuilder: (BuildContext context, int index) {
//         //               return ListTile(
//         //                   title: MoneyTrendsWidget(
//         //                 title: moneyTrends[index].title,
//         //                 image: moneyTrends[index].urlToImage,
//         //                 description: moneyTrends[index].description,
//         //                 author: moneyTrends[index].author,
//         //               ));
//         //             }),
//         );
//   }
// }
