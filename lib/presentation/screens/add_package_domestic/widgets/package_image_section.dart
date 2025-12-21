import 'package:elysian_admin/features/add_package/logic/bloc/add_package_bloc.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_event.dart';
import 'package:elysian_admin/features/add_package/logic/bloc/add_package_state.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/widgets/add_image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'dart:io' as io;

class PackageImagesSection extends StatelessWidget {
  const PackageImagesSection({super.key});

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
                      state.imageError != null
                          ? Colors.red
                          : Colors.transparent,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Package Images',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.images.isNotEmpty ||
                      state.existingImageUrls.isNotEmpty)
                    Container(
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            state.existingImageUrls.length +
                            state.images.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final bool isExisting =
                              index < state.existingImageUrls.length;
                          final imageSource =
                              isExisting
                                  ? state.existingImageUrls[index]
                                  : state
                                      .images[index -
                                          state.existingImageUrls.length]
                                      .path;

                          return Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image:
                                        isExisting
                                            ? NetworkImage(imageSource)
                                                as ImageProvider
                                            : FileImage(io.File(imageSource)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    if (isExisting) {
                                      context.read<AddPackageBloc>().add(
                                        RemoveExistingPackageImage(imageSource),
                                      );
                                    } else {
                                      context.read<AddPackageBloc>().add(
                                        RemovePackageImage(
                                          index -
                                              state.existingImageUrls.length,
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  if (state.status == ImagePickerStatus.picking)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Lottie.network(
                          'https://assets2.lottiefiles.com/packages/lf20_w51pcehl.json', // Travel animation
                          height: 100,
                          width: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                  AddImageButton(
                    onTap: () {
                      context.read<AddPackageBloc>().add(PickPackageImages());
                    },
                  ),
                ],
              ),
            ),
            if (state.imageError != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  state.imageError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
