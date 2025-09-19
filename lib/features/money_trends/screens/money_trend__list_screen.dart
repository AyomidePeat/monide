import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:monide/core/constants/colors.dart';
import 'package:monide/features/atm_status/presentation/providers/map_provider.dart';
import 'package:monide/widgets/money_trend_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MoneyTrendsScreen extends ConsumerStatefulWidget {
  const MoneyTrendsScreen({super.key});

  @override
  ConsumerState<MoneyTrendsScreen> createState() => _MoneyTrendsScreenState();
}

class _MoneyTrendsScreenState extends ConsumerState<MoneyTrendsScreen> {
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapProvider.notifier).fetchMoneyTrends();
    });
  }

  Future<void> _refreshTrends() async {
    _logger.i('Refreshing money trends');
    await ref.read(mapProvider.notifier).fetchMoneyTrends(isRefresh: true);
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _logger.w('Could not launch URL: $url');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: deepBlue,
              content: Text(
                'Could not open article',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
            ),
          );
        }
      }
    } catch (e) {
      _logger.e('Error launching URL: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: deepBlue,
            content: Text(
              'Error opening article: $e',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);

    return Scaffold(
      backgroundColor: deepBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            const Text(
              'Money Trends for You',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTrends,
        color: Colors.white,
        backgroundColor: deepBlue,
        child: Stack(
          children: [
            mapState.isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : mapState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mapState.error!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => ref.read(mapProvider.notifier).fetchMoneyTrends(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: deepBlue,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : mapState.moneyTrends.isEmpty
                        ? const Center(
                            child: Text(
                              'No money trends available',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: mapState.moneyTrends.length,
                            itemBuilder: (context, index) {
                              final trend = mapState.moneyTrends[index];
                              return ListTile(
                                title: MoneyTrendsWidget(
                                  title: trend.title,
                                  image: trend.imageUrl,
                                  description: trend.description,
                                  source: trend.url,
                                ),
                                onTap: () => _launchURL(trend.url),
                              );
                            },
                          ),
          ],
        ),
      ),
    );
  }
}