import 'package:elysian_admin/features/add_package/data/models/package_model.dart';
import 'package:elysian_admin/presentation/screens/package_details/widgets/accomudation_container.dart';
import 'package:elysian_admin/presentation/screens/package_details/widgets/image_carousel.dart';
import 'package:elysian_admin/presentation/screens/package_details/widgets/appbar.dart';
import 'package:elysian_admin/presentation/screens/package_details/widgets/price_doesnot_includes.dart';
import 'package:elysian_admin/presentation/screens/package_details/widgets/price_includes.dart';
import 'package:flutter/material.dart';
import 'widgets/info_card.dart';
import 'package:elysian_admin/presentation/screens/package_details/bloc/package_details_bloc.dart';
import 'package:elysian_admin/presentation/screens/package_details/bloc/package_details_event.dart';
import 'package:elysian_admin/presentation/screens/package_details/bloc/package_details_state.dart';
import 'package:elysian_admin/features/add_package/domain/repositories/package_repository.dart';
import 'package:elysian_admin/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/add_package.dart';
import 'package:elysian_admin/presentation/screens/package_details/widgets/bottom_price_bar.dart';

class PackageDetails extends StatelessWidget {
  final PackageModel? package;

  const PackageDetails({super.key, this.package});

  @override
  @override
  Widget build(BuildContext context) {
    if (package == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Details")),
        body: const Center(child: Text("No package data available")),
      );
    }

    final pkg = package!;

    return BlocProvider(
      create:
          (context) =>
              PackageDetailsBloc(packageRepository: sl<PackageRepository>()),
      child: BlocConsumer<PackageDetailsBloc, PackageDetailsState>(
        listener: (context, state) {
          if (state is PackageDetailsDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Package deleted successfully')),
            );
            Navigator.pop(context); // Go back to list
          } else if (state is PackageDetailsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is PackageDetailsLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PackageDetailsAppbar(
              onDelete: () {
                context.read<PackageDetailsBloc>().add(DeletePackageEvent(pkg));
              },
              onEdit: () {
                // Determine tour type string for navigation if needed or pass directly
                // Logic for editing will be handled by navigating to AddPackagePage with arguments
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPackagePage(packageToEdit: pkg),
                  ),
                );
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image Section (Carousel)
                  ImageCarousel(images: pkg.images),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pkg.categoryName.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              pkg.categoryName,
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          pkg.packageName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Info Cards
                        Row(
                          children: [
                            InfoCard(
                              label: 'Included',
                              icon: Icons.flight_takeoff,
                              backgroundColor: const Color(
                                0xFFC8E6C9,
                              ), // Light Green
                              iconColor: const Color(0xFF2E7D32),
                            ),
                            const SizedBox(width: 12),
                            InfoCard(
                              label: pkg.duration,
                              icon: Icons.wb_sunny_outlined,
                              backgroundColor: const Color(
                                0xFFFFE0B2,
                              ), // Light Orange
                              iconColor: const Color(0xFFEF6C00),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Travel Timeline
                        const Text(
                          'Travel Timeline',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          pkg.duration, // Using duration string here
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Inclusions
                        const Text(
                          'Inclusions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              202,
                              218,
                              231,
                            ), // Light Blue
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children:
                                pkg.standardInclusions.map((inclusion) {
                                  // Mapping standard inclusions strings to icons if possible, or generic icon
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        size: 20,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(inclusion),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (pkg.accommodation.isNotEmpty)
                          AccomudationContainer(
                            icon: Icons.hotel,
                            title: 'Accommodation',
                            bullets: pkg.accommodation,
                          ),
                        const SizedBox(height: 20),

                        if (pkg.highlights.isNotEmpty)
                          AccomudationContainer(
                            icon: Icons.highlight,
                            title: 'Highlights',
                            bullets: [pkg.highlights],
                          ),
                        const SizedBox(height: 20),
                        if (pkg.meals.isNotEmpty)
                          AccomudationContainer(
                            icon: Icons.restaurant,
                            title: 'Meals',
                            bullets: pkg.meals,
                          ),
                        const SizedBox(height: 20),

                        if (pkg.inclusions.isNotEmpty)
                          PriceIncludes(items: pkg.inclusions),

                        const SizedBox(height: 20),
                        if (pkg.exclusions.isNotEmpty)
                          PriceDoesNotIncludes(items: pkg.exclusions),

                        const SizedBox(height: 20),

                        // Itinerary
                        const Text(
                          "Itinerary",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...pkg.itinerary.entries.map((entry) {
                          final day = entry.key;
                          final dayData = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Day $day",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(dayData.description),
                                if (dayData.images.isNotEmpty)
                                  SizedBox(
                                    height: 100,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children:
                                          dayData.images
                                              .map(
                                                (img) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 8.0,
                                                      ),
                                                  child: Image.network(
                                                    img,
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 80), // Bottom padding
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomPriceBar(price: pkg.price),
          );
        },
      ),
    );
  }
}
