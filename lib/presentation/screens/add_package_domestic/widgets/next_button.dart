import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_state.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/second_page/second_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: BlocBuilder<AddPackageBloc, AddPackageState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () {
              final bloc = context.read<AddPackageBloc>();
              bloc.add(ValidateForm());

              // We need to check if validation passed.
              // Since validation is synchronous in current bloc (emit is synchronous for this event generally, but bloc processing is async in theory).
              // However, simpler is to check state manually here OR assume after calling ValidateForm, if state is valid we proceed.
              // Actually better pattern is to Navigate based on state listener, but for simplicity here with "validations under columns",
              // We can just check fields directly here before dispatching ValidateForm? No, duplicate logic.
              // Dispatch ValidateForm FIRST, then check state? BLoC updates are async.
              // So, we should listen to the state change. Or, we can just perform the check here for navigation purposes?
              // The user wants errors "displayed under that particular box".
              // So updating the state with errors is the way.
              // If we dispatch ValidateForm, the UI will rebuild with errors.
              // We need to know if we should navigate.
              // Let's validate locally to decide navigation (or check bloc state after a slight delay, which is bad).
              // Better: Check validity based on current state values logic (duplicated) OR
              // make ValidateForm return logic? No.
              // Let's just reproduce the check here for decision making, and dispatch ValidateForm to show errors.

              final isValid =
                  state.packageName.trim().isNotEmpty &&
                  state.numberOfDays.isNotEmpty &&
                  state.highlights.trim().isNotEmpty &&
                  (state.images.isNotEmpty ||
                      state.existingImageUrls.isNotEmpty) &&
                  state.selectedInclusions.isNotEmpty;

              if (isValid) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider.value(
                          value: bloc,
                          child: const AddPackageSecondPage(),
                        ),
                  ),
                );
              } else {
                // Trigger showing errors
                bloc.add(ValidateForm());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Next page', style: TextStyle(color: Colors.white)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
