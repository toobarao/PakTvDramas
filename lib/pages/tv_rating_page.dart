import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tv_rating.dart';
import '../providers/tv_ratings_provider.dart';
import '../widgets/drama_rating_card.dart';

class TvRatingPage extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();

  TvRatingPage({super.key});

  Future<void> _selectDate(BuildContext context, TvRatingProvider provider) async {
    final DateTime now = DateTime.now();
    final DateTime lockDate = now.subtract(const Duration(days: 9));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: lockDate.subtract(const Duration(days: 1)),
      firstDate: DateTime(2000),
      lastDate: lockDate.subtract(const Duration(days: 1)),
    );

    if (picked != null) {
      final String formatted = picked.toIso8601String().split('T')[0];
      dateController.text = formatted;
      provider.fetchRatingsForDate(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TvRatingProvider>(
      builder: (context, provider, _) {
        final dramas = provider.ratings;
        final List<TvRating> top10Sorted = dramas
            .where((d) => d.ml_ratings != null)
            .toList()
          ..sort((a, b) => b.ml_ratings!.compareTo(a.ml_ratings!));
        final top10 = top10Sorted.take(10).toList();


        return provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("TV Rating", style: Theme.of(context).textTheme.headlineMedium),
                    SizedBox(
                      width: 120,

                      child: TextField(
                        controller: dateController,
                        readOnly: true,
                        style: const TextStyle(fontSize: 12),
                        onTap: () => _selectDate(context, provider),
                        decoration: InputDecoration(
                          hintText: provider.currentDate,
                          hintStyle: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                          suffixIcon: Icon(Icons.calendar_today, size: 18, color: Theme.of(context).primaryColor),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 15),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final drama = top10[index];
                    return DramaRatingsCard(item: drama, index: index);
                  },
                  childCount: top10.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
