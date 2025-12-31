import 'package:elysian_admin/presentation/screens/add_package_domestic/second_page/widgets/bullet_textfield.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/second_page/widgets/itinerary_section.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/second_page/widgets/selection_card.dart';
import 'package:flutter/material.dart';

import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPackageForm extends StatelessWidget {
  const AddPackageForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPackageBloc, AddPackageState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const ItinerarySection(),
              const SizedBox(height: 80),

              SectionCard(
                title: 'Accommodation',
                child: _buildDynamicSection(
                  context,
                  state.accommodationList,
                  SectionType.accommodation,
                  'e.g., 02 nights at Abad Copper Castle @Munar',
                  errorText: state.accommodationError,
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Meals',
                child: _buildDynamicSection(
                  context,
                  state.mealsList,
                  SectionType.meals,
                  'e.g., Daily Breakfast except on Day 01',
                  errorText: state.mealsError,
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Tour Manager',
                child: _buildDynamicSection(
                  context,
                  state.tourManagerList,
                  SectionType.tourManager,
                  'e.g.,Tour Manager',
                  errorText: state.tourManagerError,
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'What Your Price Includes',
                child: _buildDynamicSection(
                  context,
                  state.inclusionsList,
                  SectionType.inclusions,
                  'e.g., Accommodation in the mentioned hotels',
                  errorText: state.inclusionsError,
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'What Your Price Does not Includes',
                child: _buildDynamicSection(
                  context,
                  state.exclusionsList,
                  SectionType.exclusions,
                  'e.g., Any transport services to or from Ex hub',
                  errorText: state.exclusionsError,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDynamicSection(
    BuildContext context,
    List<String> items,
    SectionType sectionType,
    String placeholder, {
    String? errorText,
  }) {
    return Column(
      children: [
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: BulletTextField(
              value: item,
              onChanged: (value) {
                context.read<AddPackageBloc>().add(
                  UpdateSectionItem(
                    section: sectionType,
                    index: index,
                    item: value,
                  ),
                );
              },
              onSubmitted: (_) {
                // When pressing Enter on an existing item, add a new empty item below
                // or just trigger the creation of a new line if it's the last one.
                // For simplicity, we can add an empty item to the list.
                context.read<AddPackageBloc>().add(
                  AddSectionItem(section: sectionType, item: ''),
                );
              },
              onRemove: () {
                context.read<AddPackageBloc>().add(
                  RemoveSectionItem(section: sectionType, index: index),
                );
              },
            ),
          );
        }).toList(),
        BulletTextField(
          value: '',
          hintText: items.isEmpty ? placeholder : null,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              context.read<AddPackageBloc>().add(
                AddSectionItem(section: sectionType, item: value),
              );
            }
          },
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
