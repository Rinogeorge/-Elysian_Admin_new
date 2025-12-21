// lib/presentation/pages/add_package_page.dart
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_state.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/second_page/widgets/add_packsgeform.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/second_page/widgets/upload_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPackageSecondPage extends StatelessWidget {
  const AddPackageSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPackageBloc, AddPackageState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Package uploaded successfully!')),
          );
          Navigator.of(context).pop(); // Go back to previous screen
        }
      },
      child: BlocBuilder<AddPackageBloc, AddPackageState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: Text(
                state.packageId != null ? 'Edit Package' : 'Add Package',
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
            ),
            body: const AddPackageForm(),
            floatingActionButton: const UploadButton(),
          );
        },
      ),
    );
  }
}
