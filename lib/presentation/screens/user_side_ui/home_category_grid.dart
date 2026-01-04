import 'package:cached_network_image/cached_network_image.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/user_side_injection_container.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/bloc/user_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCategoryGrid extends StatefulWidget {
  const HomeCategoryGrid({super.key});

  @override
  State<HomeCategoryGrid> createState() => _HomeCategoryGridState();
}

class _HomeCategoryGridState extends State<HomeCategoryGrid> {
  @override
  void initState() {
    super.initState();
    initUserSide();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => userSl<UserCategoryBloc>()..add(LoadUserCategories()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Categories"), centerTitle: true),
        body: BlocBuilder<UserCategoryBloc, UserCategoryState>(
          builder: (context, state) {
            if (state is UserCategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserCategoryError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is UserCategoryLoaded) {
              if (state.categories.isEmpty) {
                return const Center(child: Text("No categories found"));
              }
              // Horizontal Scroll Grid View
              return SizedBox(
                height: 280,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Single row to act as horizontal list
                    childAspectRatio:
                        1.4, // Width/Height relationship inversed in horizontal? No, Cross/Main. Height/Width = 240/180 = 1.33. GridView Horizontal: ratio is Height/Width?
                    // Docs: ratio = crossAxisExtent / mainAxisExtent.
                    // CrossAxis is Vertical (Height). MainAxis is Horizontal (Width).
                    // Ratio = Height / Width.
                    // 240 / 180 = 1.33.
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: category.imageUrl,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                errorWidget:
                                    (context, url, error) => const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Center(
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12.0, right: 12.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Color.fromARGB(
                                  255,
                                  178,
                                  209,
                                  235,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
