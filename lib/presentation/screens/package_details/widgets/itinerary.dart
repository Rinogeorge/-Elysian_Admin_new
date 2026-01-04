import 'package:elysian_admin/features/add_package/data/models/package_model.dart';
import 'package:elysian_admin/presentation/screens/package_details/bloc/itinerary_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Itinerary extends StatelessWidget {
  final Map<String, ItineraryDay> itinerary;

  const Itinerary({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    // Sort keys to ensure Day 1, Day 2, order
    final days =
        itinerary.keys.toList()..sort(
          (a, b) => int.parse(a).compareTo(int.parse(b)),
        ); // Assuming keys are "1", "2" etc.

    if (days.isEmpty) return const SizedBox.shrink();

    return BlocProvider(
      create: (_) => ItineraryCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Itinerary",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Day Selector
          SizedBox(
            height: 80,
            child: BlocBuilder<ItineraryCubit, ItineraryState>(
              buildWhen:
                  (previous, current) => previous.dayIndex != current.dayIndex,
              builder: (context, state) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final isSelected = index == state.dayIndex;
                    return GestureDetector(
                      onTap: () {
                        context.read<ItineraryCubit>().selectDay(index);
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFF1565C0)
                                  : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wb_sunny_outlined,
                              color: isSelected ? Colors.yellow : Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Day ${days[index]}",
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // Selected Day Details
          BlocBuilder<ItineraryCubit, ItineraryState>(
            builder: (context, state) {
              final dayKey = days[state.dayIndex];
              final dayData = itinerary[dayKey]!;
              final images = dayData.images;

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100, // Light blue background
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Day $dayKey",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Image Carousel
                    if (images.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: PageView.builder(
                                onPageChanged: (index) {
                                  context.read<ItineraryCubit>().changeImage(
                                    index,
                                  );
                                },
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    images[index],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        child: const Center(
                                          child: Icon(Icons.broken_image),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          if (images.length > 1) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(images.length, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        state.imageIndex == index
                                            ? Colors.blue.shade900
                                            : Colors.grey.shade400,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ],
                      ),
                    const SizedBox(height: 16),
                    Text(
                      dayData.description,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
