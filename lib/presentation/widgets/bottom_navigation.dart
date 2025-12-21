import 'package:elysian_admin/features/auth/logic/bloc/bottom_navigation/bloc/botton_nav_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/bottom_navigation/bloc/botton_nav_event.dart';
import 'package:elysian_admin/features/auth/logic/bloc/bottom_navigation/bloc/botton_nav_state.dart';
import 'package:elysian_admin/presentation/screens/category_add/category_add.dart';
import 'package:elysian_admin/presentation/screens/chat/chat.dart';
import 'package:elysian_admin/presentation/screens/enquries/enquries.dart';
import 'package:elysian_admin/presentation/screens/home/home.dart';
import 'package:elysian_admin/presentation/screens/package_list/package_list.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatelessWidget {
  final NavigationBloc bloc;

  const MainNavigationScreen({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NavigationState>(
      stream: bloc.state,
      initialData: bloc.currentState,
      builder: (context, snapshot) {
        final currentIndex = snapshot.data?.selectedIndex ?? 0;

        return Scaffold(
          body: _getPage(currentIndex),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: currentIndex,
            onTap: (index) => bloc.add(NavigateToPage(index)),
          ),
        );
      },
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return const PackageList();
      case 2:
        return const CategoryAdd();
      case 3:
        return const EnquriesPage();
      case 4:
        return ChatPage();
      default:
        return const DashboardPage();
    }
  }
}

// Custom Bottom Navigation Widget
class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  double _getIndicatorLeftPosition(int index, double screenWidth) {
    final itemWidth = screenWidth / 5;
    final circleSize = index == 2 ? 60.0 : 52.0;

    // Calculate the center position of each tab
    // Each tab is centered in its section, so we need to position the circle
    // at the center of the tab item
    final tabCenter = (itemWidth * index) + (itemWidth / 2);

    // Subtract half the circle width to center it
    return tabCenter - (circleSize / 2);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1E5BA8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Animated white circle indicator (behind items)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _getIndicatorLeftPosition(widget.currentIndex, screenWidth),
            bottom: 9,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: widget.currentIndex == 2 ? 60 : 52,
              height: widget.currentIndex == 2 ? 60 : 52,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          // Navigation items (on top)
          Row(
            children: [
              _buildNavItem(0, Icons.home_outlined, 'Home'),
              _buildNavItem(1, Icons.card_giftcard_outlined, 'Packages'),
              _buildAddButton(),
              _buildNavItem(3, Icons.description_outlined, 'Enquiries'),
              _buildNavItem(4, Icons.chat_bubble_outline, 'Chat'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = widget.currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => widget.onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Icon centered in the white circle
              Positioned(
                top: 13,
                child: Icon(
                  icon,
                  color:
                      isSelected
                          ? const Color(0xFF1E5BA8)
                          : Colors.white.withOpacity(0.6),
                  size: 26,
                ),
              ),
              // Label below the circle (hidden when selected)
              if (!isSelected)
                Positioned(
                  bottom: 8,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    final isSelected = widget.currentIndex == 2;

    return Expanded(
      child: InkWell(
        onTap: () => widget.onTap(2),
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Icon centered in the white circle
              Positioned(
                top: 11,
                child: Icon(
                  Icons.add,
                  color: isSelected ? const Color(0xFF1E5BA8) : Colors.white,
                  size: 32,
                ),
              ),
              // Label below the circle (hidden when selected)
              if (!isSelected)
                Positioned(
                  bottom: 8,
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
