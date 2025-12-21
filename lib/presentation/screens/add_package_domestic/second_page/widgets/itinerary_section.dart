import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_state.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/second_page/widgets/day_detail_card.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/second_page/widgets/day_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItinerarySection extends StatelessWidget {
  const ItinerarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPackageBloc, AddPackageState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Itinerary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Detailed Day-By -Day Plan',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.totalDays,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  return DaySelector(
                    day: day,
                    isSelected: state.selectedDay == day,
                    onTap: () {
                      context.read<AddPackageBloc>().add(
                        SelectItineraryDay(day),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            DayDetailCard(
              day: state.selectedDay,
              existingImages:
                  state.existingDayImageUrls[state.selectedDay] ?? [],
              newImages:
                  state.dayImages[state.selectedDay]
                      ?.map((e) => e.path)
                      .toList() ??
                  [],
              initialDescription: state.dayDescriptions[state.selectedDay],
              onDescriptionChanged: (description) {
                context.read<AddPackageBloc>().add(
                  UpdateDayDescription(
                    day: state.selectedDay,
                    description: description,
                  ),
                );
              },
              onImageSelected: () {
                // Trigger image picking via Bloc
                context.read<AddPackageBloc>().add(
                  PickDayImage(state.selectedDay),
                );
              },
              onNewImageRemove: (index) {
                context.read<AddPackageBloc>().add(
                  RemoveDayImage(day: state.selectedDay, imageIndex: index),
                );
              },
              onExistingImageRemove: (url) {
                context.read<AddPackageBloc>().add(
                  RemoveExistingDayImage(day: state.selectedDay, imageUrl: url),
                );
              },
              locationError: state.itineraryLocationErrors[state.selectedDay],
              imageError: state.itineraryImageErrors[state.selectedDay],
            ),
          ],
        );
      },
    );
  }
}
