import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PackageDetailsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const PackageDetailsAppbar({super.key, this.onDelete, this.onEdit});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Package Details',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.black),
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            if (onDelete != null) {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Package'),
                      content: const Text(
                        'Do you want to delete this package?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            onDelete!(); // Trigger delete
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
            }
          },
        ),
      ],
    );
  }
}
