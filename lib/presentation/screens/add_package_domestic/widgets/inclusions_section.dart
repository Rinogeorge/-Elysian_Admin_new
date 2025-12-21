import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_state.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/checkbox_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InclusionsSection extends StatelessWidget {
  const InclusionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPackageBloc, AddPackageState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      state.inclusionsError != null
                          ? Colors.red
                          : Colors.transparent,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inclusions',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildCheckbox(context, state, 'Hotels'),
                            _buildCheckbox(context, state, 'Meals'),
                            _buildCheckbox(context, state, 'Sightseeing'),
                            _buildCheckbox(context, state, 'Guide'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            _buildCheckbox(context, state, 'Tour Manager'),
                            _buildCheckbox(context, state, 'Flight'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (state.inclusionsError != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  state.inclusionsError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCheckbox(
    BuildContext context,
    AddPackageState state,
    String label,
  ) {
    return CheckboxItem(
      label: label,
      value: state.selectedInclusions.contains(label),
      onChanged: (val) {
        context.read<AddPackageBloc>().add(ToggleInclusion(label));
      },
    );
  }
}
