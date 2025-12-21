import 'dart:io';

import 'package:elysian_admin/core/validation/input_validator.dart';
import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_bloc.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_event.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_state.dart';
import 'package:elysian_admin/injection_container.dart';
import 'package:elysian_admin/presentation/screens/add_package_domestic/add_package.dart';
import 'package:elysian_admin/presentation/screens/category_add/widgets/category_input_section.dart';
import 'package:elysian_admin/presentation/screens/category_add/widgets/category_list.dart';
import 'package:elysian_admin/presentation/screens/category_add/widgets/image_upload_section.dart';
import 'package:elysian_admin/presentation/screens/category_add/widgets/travel_type_segment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final categoryNameController = TextEditingController();
  final categoryNameValidator = sl<InputValidator<String>>(
    instanceName: 'categoryNameValidator',
  );
  final imagePathValidator = sl<InputValidator<String>>(
    instanceName: 'imagePathValidator',
  );

  String? categoryNameError;
  String? imageError;

  @override
  void initState() {
    super.initState();
    // Load categories on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(
        const LoadCategories(travelType: TravelType.domestic),
      );
    });

    // Add listener for real-time validation
    categoryNameController.addListener(_validateCategoryName);
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  void _validateCategoryName() {
    final result = categoryNameValidator.validate(categoryNameController.text);
    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            categoryNameError = failure.message;
          });
        }
      },
      (_) {
        if (mounted) {
          setState(() {
            categoryNameError = null;
          });
        }
      },
    );
  }

  void _validateImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      setState(() {
        imageError = 'Please select an image';
      });
      return;
    }

    final result = imagePathValidator.validate(imagePath);
    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            imageError = failure.message;
          });
        }
      },
      (_) {
        if (mounted) {
          setState(() {
            imageError = null;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CategorySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              categoryNameController.clear();
            } else if (state is CategoryLoaded &&
                state.successMessage != null) {
              // Show success message from CategoryLoaded state
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: Colors.green,
                ),
              );
              categoryNameController.clear();
            }
          },
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              final selectedTravelType =
                  state is CategoryLoaded
                      ? state.selectedTravelType
                      : state is CategoryInitial
                      ? state.selectedTravelType
                      : state is CategoryLoading
                      ? state.selectedTravelType
                      : state is CategoryError
                      ? state.selectedTravelType
                      : TravelType.domestic;

              final categories =
                  state is CategoryLoaded
                      ? state.categories
                      : <CategoryEntity>[];
              final selectedImagePath =
                  state is CategoryLoaded ? state.selectedImagePath : null;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<CategoryBloc>().add(
                    LoadCategories(travelType: selectedTravelType),
                  );
                  // Wait a bit for the reload to complete
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Travel Type Segment
                      Center(
                        child: TravelTypeSegment(
                          selectedType: selectedTravelType,
                          onTypeChanged: (type) {
                            context.read<CategoryBloc>().add(
                              ChangeTravelType(travelType: type),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Image Upload Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageUploadSection(
                            imagePath: selectedImagePath,
                            onImageSelected: (path) {
                              _validateImage(path);
                              context.read<CategoryBloc>().add(
                                SetImagePath(imagePath: path),
                              );
                            },
                            onImageRemoved: () {
                              setState(() {
                                imageError = null;
                              });
                              context.read<CategoryBloc>().add(
                                const ClearImageSelection(),
                              );
                            },
                            onAddMoreImages: () {
                              // Same as image selection
                            },
                          ),
                          if (imageError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 4),
                              child: Text(
                                imageError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Category Input Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryInputSection(
                            controller: categoryNameController,
                            errorText: categoryNameError,
                            onAdd: () {
                              // Validate category name
                              final nameValidation = categoryNameValidator
                                  .validate(categoryNameController.text);

                              // Validate image
                              _validateImage(selectedImagePath);

                              // Check if both validations passed
                              nameValidation.fold(
                                (failure) {
                                  // Don't show snackbar, error is already shown below the field
                                  // Just return to prevent submission
                                  return;
                                },
                                (validName) {
                                  if (imageError != null) {
                                    // Image error is already shown below the image section
                                    // Just return to prevent submission
                                    return;
                                  }

                                  // Both validations passed, add category
                                  context.read<CategoryBloc>().add(
                                    AddCategory(
                                      name: validName,
                                      imagePath: selectedImagePath!,
                                      travelType: selectedTravelType,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Category List
                      if (state is CategoryLoading && categories.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        CategoryList(
                          categories: categories,
                          onEdit: (category) {
                            // Show edit dialog
                            _showEditDialog(context, category);
                          },
                          onDelete: (categoryId) {
                            _showDeleteConfirmation(context, categoryId);
                          },
                        ),
                      const SizedBox(height: 80), // Space for FAB
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPackagePage()));
        },
        backgroundColor: const Color(0xFF90EE90),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Packages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, CategoryEntity category) {
    final nameController = TextEditingController(text: category.name);
    String? selectedImagePath;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => StatefulBuilder(
            builder:
                (context, setState) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Container(
                    width: double.maxFinite,
                    constraints: const BoxConstraints(maxWidth: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.blue.shade50.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with gradient
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF1E5BA8),
                                const Color(0xFF2E7BC4),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'Edit Category',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Content
                        Flexible(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category Name Input
                                Text(
                                  'Category Name',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E5BA8),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter category name',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1E5BA8),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Image Section
                                Text(
                                  'Category Image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E5BA8),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Image Preview with shadow
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child:
                                        selectedImagePath != null
                                            ? Image.file(
                                              File(selectedImagePath!),
                                              height: 160,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.network(
                                              category.imageUrl,
                                              height: 160,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  height: 160,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.grey.shade200,
                                                        Colors.grey.shade300,
                                                      ],
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.image_outlined,
                                                        size: 50,
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade400,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        'No image available',
                                                        style: TextStyle(
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Change Image Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final XFile? image = await picker
                                          .pickImage(
                                            source: ImageSource.gallery,
                                          );
                                      if (image != null) {
                                        setState(() {
                                          selectedImagePath = image.path;
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.collections_rounded,
                                      size: 20,
                                    ),
                                    label: const Text(
                                      'Choose New Image',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF1E5BA8),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: const Color(
                                            0xFF1E5BA8,
                                          ).withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Action Buttons
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey.shade700,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.trim().isNotEmpty) {
                                    context.read<CategoryBloc>().add(
                                      UpdateCategory(
                                        categoryId: category.id,
                                        name: nameController.text.trim(),
                                        imagePath: selectedImagePath,
                                      ),
                                    );
                                    Navigator.pop(dialogContext);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E5BA8),
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String categoryId) {
    print('[CategoryAdd] Delete confirmation for category ID: $categoryId');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning Icon Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            size: 48,
                            color: Colors.red.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Delete Category',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E5BA8),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Are you sure you want to delete this category?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.orange.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'This action cannot be undone.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.orange.shade900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              print(
                                '[CategoryAdd] Delete button pressed for ID: $categoryId',
                              );
                              context.read<CategoryBloc>().add(
                                DeleteCategory(categoryId: categoryId),
                              );
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Deleting category...',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.orange.shade600,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
