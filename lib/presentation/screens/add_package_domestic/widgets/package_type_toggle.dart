import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_bloc.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_event.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_state.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageTypeToggle extends StatelessWidget {
  const PackageTypeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final isDomestic =
            state is CategoryLoaded
                ? state.selectedTravelType == TravelType.domestic
                : state is CategoryLoading
                ? state.selectedTravelType == TravelType.domestic
                : true; // Default

        return Row(
          children: [
            Expanded(
              child: ToggleButton(
                label: 'Domestic',
                icon: Icons.home,
                isSelected: isDomestic,
                onTap: () {
                  context.read<CategoryBloc>().add(
                    const ChangeTravelType(travelType: TravelType.domestic),
                  );
                  context.read<AddPackageBloc>().add(
                    const TourTypeChanged('Domestic'),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.sync_alt, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: ToggleButton(
                label: 'International',
                icon: Icons.flight,
                isSelected: !isDomestic,
                onTap: () {
                  context.read<CategoryBloc>().add(
                    const ChangeTravelType(
                      travelType: TravelType.international,
                    ),
                  );
                  context.read<AddPackageBloc>().add(
                    const TourTypeChanged('International'),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
