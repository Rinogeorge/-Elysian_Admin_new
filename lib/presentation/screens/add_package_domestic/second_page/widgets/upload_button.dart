import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPackageBloc, AddPackageState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          onPressed:
              state.isSubmitting
                  ? null
                  : () {
                    context.read<AddPackageBloc>().add(SubmitPackage());
                  },
          backgroundColor:
              state.isSubmitting ? Colors.grey : const Color(0xFF4CAF50),
          label:
              state.isSubmitting
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text(
                    'Upload',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          icon: state.isSubmitting ? null : const Icon(Icons.upload),
        );
      },
    );
  }
}
