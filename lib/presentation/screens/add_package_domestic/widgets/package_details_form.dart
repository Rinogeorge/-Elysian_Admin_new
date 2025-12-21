import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_state.dart';
import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_bloc.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_event.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_state.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/customdropdown_field.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/customtext_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageDetailsForm extends StatelessWidget {
  const PackageDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Select Category',
          style: TextStyle(
            color: Color(0xFF1565C0),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            final categories =
                state is CategoryLoaded ? state.categories : <CategoryEntity>[];

            return CustomDropdownField<CategoryEntity>(
              label: 'Select Category',
              value:
                  state is CategoryLoaded && state.selectedCategory != null
                      ? state.selectedCategory
                      : null,
              items:
                  categories.map((e) {
                    return DropdownMenuItem<CategoryEntity>(
                      value: e,
                      child: Text(e.name),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<CategoryBloc>().add(
                    SelectCategory(category: value),
                  );
                }
              },
            );
          },
        ),
        const SizedBox(height: 16),
        BlocBuilder<AddPackageBloc, AddPackageState>(
          builder: (context, state) {
            return Column(
              children: [
                const Text(
                  'Package Name',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  label: 'Enter Package name',
                  errorText: state.packageNameError,
                  onChanged: (value) {
                    context.read<AddPackageBloc>().add(
                      PackageNameChanged(value),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Price',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  label: 'Enter Price',
                  errorText: state.priceError,
                  onChanged: (value) {
                    context.read<AddPackageBloc>().add(PriceChanged(value));
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Number of days',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                CustomDropdownField<String>(
                  label: 'Number of days',
                  value:
                      state.numberOfDays.isNotEmpty ? state.numberOfDays : null,
                  errorText: state.numberOfDaysError,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<AddPackageBloc>().add(
                        NumberOfDaysChanged(value),
                      );
                    }
                  },
                  items:
                      [
                        '20D/19N',
                        '19D/18N',
                        '18D/17N',
                        '17D/16N',
                        '16D/15N',
                        '15D/14N',
                        '14D/13N',
                        '13D/12N',
                        '12D/11N',
                        '11D/10N',
                        '10D/9N',
                        '9D/8N',
                        '8D/7N',
                        '7D/6N',
                        '6D/5N',
                        '5D/4N',
                        '4D/3N',
                        '3D/2N',
                        '2D/1N',
                      ].map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
