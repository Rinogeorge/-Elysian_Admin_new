import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_state.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/customtext_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HighlightsSection extends StatelessWidget {
  const HighlightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPackageBloc, AddPackageState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Highlights',
                style: TextStyle(
                  color: Color(0xFF1565C0),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Enter highlights (one per line)',
                maxLines: 6,
                errorText: state.highlightsError,
                onChanged: (value) {
                  context.read<AddPackageBloc>().add(HighlightsChanged(value));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
