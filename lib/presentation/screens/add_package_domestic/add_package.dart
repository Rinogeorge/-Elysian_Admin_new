import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_bloc.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_event.dart';
import 'package:elysian_admin/injection_container.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/highlight_section.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/inclusions_section.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/next_button.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/package_details_form.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/package_image_section.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/package_type_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elysian_admin/features/add_package/data/models/package_model.dart';
import 'package:elysian_admin/features/add_package/domain/repositories/package_repository.dart';
import 'package:elysian_admin/core/services/cloudinary_service.dart';

class AddPackagePage extends StatelessWidget {
  final PackageModel? packageToEdit;

  const AddPackagePage({super.key, this.packageToEdit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<CategoryBloc>()..add(
                    const LoadCategories(travelType: TravelType.domestic),
                  ),
        ),
        BlocProvider(
          create: (context) {
            final bloc = AddPackageBloc(
              cloudinaryService: sl<CloudinaryService>(),
              packageRepository: sl<PackageRepository>(),
            );
            if (packageToEdit != null) {
              bloc.add(InitializeForm(package: packageToEdit!));
            }
            return bloc;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            packageToEdit != null ? 'Edit Package' : 'Add Package',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Only showing toggle if it's a new package, assuming type shouldn't change on edit
                // Or if we want to allow it, we should handle type changes carefully.
                // For simplicity, let's keep it but it might reset some fields if logic isn't careful.
                const PackageTypeToggle(),
                const SizedBox(height: 20),
                const PackageImagesSection(),
                const SizedBox(height: 20),
                const PackageDetailsForm(),
                const SizedBox(height: 20),
                const InclusionsSection(),
                const SizedBox(height: 20),
                const HighlightsSection(),
                const SizedBox(height: 30),
                const NextButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
