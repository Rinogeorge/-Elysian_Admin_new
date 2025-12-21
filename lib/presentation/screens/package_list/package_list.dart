import 'package:elysian_admin/features/add_package/data/repositories/package_repository_impl.dart';
import 'package:elysian_admin/features/package_list/logic/bloc/package_list_bloc.dart';
import 'package:elysian_admin/features/package_list/logic/bloc/package_list_event.dart';
import 'package:elysian_admin/features/package_list/logic/bloc/package_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elysian_admin/presentation/screens/package_details/package_details.dart';
import 'widgets/package_card.dart';

class PackageList extends StatelessWidget {
  const PackageList({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text(
            'Packages',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [Tab(text: 'International'), Tab(text: 'Domestic')],
          ),
        ),
        body: const TabBarView(
          children: [
            PackageListContent(type: 'International'),
            PackageListContent(type: 'Domestic'),
          ],
        ),
      ),
    );
  }
}

class PackageListContent extends StatelessWidget {
  final String type;

  const PackageListContent({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              PackageListBloc(packageRepository: PackageRepositoryImpl())
                ..add(FetchPackages(type: type)),
      child: BlocBuilder<PackageListBloc, PackageListState>(
        builder: (context, state) {
          if (state is PackageListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PackageListLoaded) {
            if (state.packages.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PackageListBloc>().add(
                    FetchPackages(type: type),
                  );
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text('No packages found')),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PackageListBloc>().add(FetchPackages(type: type));
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16, bottom: 20),
                itemCount: state.packages.length,
                itemBuilder: (context, index) {
                  final package = state.packages[index];
                  // Use first image if available, else placeholder
                  final imageUrl =
                      package.images.isNotEmpty
                          ? package.images.first
                          : 'https://via.placeholder.com/600x400?text=No+Image';

                  return PackageCard(
                    imageUrl: imageUrl,
                    title: package.packageName,
                    subtitle: package.duration,
                    price: 'INR ${package.price}',
                    onEdit: () {
                      // Navigate to edit page
                    },
                    onDelete: () {},
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PackageDetails(package: package),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is PackageListError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
