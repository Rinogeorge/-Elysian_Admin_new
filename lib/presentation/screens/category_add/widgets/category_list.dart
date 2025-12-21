import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/presentation/screens/category_add/widgets/category_list_item.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryEntity> categories;
  final Function(CategoryEntity) onEdit;
  final Function(String) onDelete;

  const CategoryList({
    super.key,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No categories yet. Add your first category!',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryListItem(
          category: category,
          onEdit: () => onEdit(category),
          onDelete: () => onDelete(category.id),
        );
      },
    );
  }
}
