import 'package:elysian_admin/features/auth/logic/bloc/drawer/drawer_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/drawer/drawer_event.dart';
import 'package:elysian_admin/features/auth/logic/bloc/drawer/drawer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DrawerBloc, DrawerState>(
      listener: (context, state) {
        if (state is DrawerLogoutSuccess) {
          // Navigation will be handled by the app's auth state listener
          Navigator.of(context).pop();
        } else if (state is DrawerDeleteAccountSuccess) {
          Navigator.of(context).pop();
        } else if (state is DrawerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<DrawerBloc, DrawerState>(
        builder: (context, state) {
          // Load user only if not already loaded or loading
          if (state is DrawerInitial || state is DrawerError) {
            context.read<DrawerBloc>().add(const LoadDrawerUser());
          }
          
          if (state is DrawerLoaded) {
            return _buildDrawerContent(context, state.user);
          } else if (state is DrawerLoading) {
            return const Drawer(
              backgroundColor: Color(0xFF1E5AA8),
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          } else {
            return _buildDrawerContent(context, null);
          }
        },
      ),
    );
  }

  Widget _buildDrawerContent(BuildContext context, user) {
    return Drawer(
      backgroundColor: const Color(0xFF1E5AA8),
      child: SafeArea(
        child: Column(
          children: [
            // User Profile Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    user?.name ?? 'Loading...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Email
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white24,
              thickness: 1,
            ),
            // Menu Options
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.edit_outlined,
                    title: 'Edit Account',
                    onTap: () {
                      Navigator.of(context).pop();
                      // TODO: Navigate to edit account screen
                    },
                  ),
                  const Divider(
                    color: Colors.white24,
                    thickness: 1,
                    height: 1,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Manage Account',
                    onTap: () {
                      Navigator.of(context).pop();
                      // TODO: Navigate to manage account screen
                    },
                  ),
                  const Divider(
                    color: Colors.white24,
                    thickness: 1,
                    height: 1,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      context.read<DrawerBloc>().add(
                            const DrawerLogoutRequested(),
                          );
                    },
                  ),
                  const Divider(
                    color: Colors.white24,
                    thickness: 1,
                    height: 1,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      _showDeleteAccountDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.black,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<DrawerBloc>().add(
                      const DrawerDeleteAccountRequested(),
                    );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

