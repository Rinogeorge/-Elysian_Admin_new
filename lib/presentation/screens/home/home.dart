import 'package:elysian_admin/features/entity/enquries.dart';
import 'package:elysian_admin/features/model/dashboard.dart';
import 'package:elysian_admin/features/model/revenue_data.dart';
import 'package:elysian_admin/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elysian_admin/features/auth/logic/bloc/drawer/drawer_bloc.dart';
import 'package:get_it/get_it.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  // Mock data (in real app, this would come from a repository/use case)
  static const _stats = DashboardStats(
    totalBookings: 35,
    activeTours: 20,
    totalUsers: 172,
  );

  static const _revenue = RevenueData(
    currentMonth: '350000 INR',
    lastMonth: '568000 INR',
    total: '2280000 INR',
  );

  static const _enquiries = [
    Enquiry(
      id: '1',
      packageName: 'Europe',
      price: 165000,
      customerName: 'Customer Sreejith P',
      imageUrl:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
    ),
    Enquiry(
      id: '2',
      packageName: 'Simply Thailand',
      price: 185000,
      customerName: 'Customer Ajas',
      imageUrl:
          'https://images.unsplash.com/photo-1528181304800-259b08848526?w=400',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<DrawerBloc>(),
      child: Builder(
        builder:
            (context) => Scaffold(
              backgroundColor: Colors.white,
              drawer: const AppDrawer(),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                title: const Text(
                  'Elysian',
                  style: TextStyle(
                    color: Color(0xFF4A90E2),
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFB8C9E8),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Dashboard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _StatsCard(stats: _stats),
                      const SizedBox(height: 24),
                      _SectionHeader(title: 'Revenue'),
                      const SizedBox(height: 16),
                      _RevenueSection(revenue: _revenue),
                      const SizedBox(height: 24),
                      const Text(
                        'Enquries !',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._enquiries.map((e) => _EnquiryCard(enquiry: e)),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}

// Presentation Components
class _StatsCard extends StatelessWidget {
  final DashboardStats stats;

  const _StatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E5AA8), Color(0xFF2B6CB8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'Total\nBooking', value: '${stats.totalBookings}'),
          _StatItem(label: 'Active\nTours', value: '${stats.activeTours}'),
          _StatItem(label: 'Total\nUsers', value: '${stats.totalUsers}'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFFB8D8E8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('View All', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

class _RevenueSection extends StatelessWidget {
  final RevenueData revenue;

  const _RevenueSection({required this.revenue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RevenueCard(
            icon: Icons.rocket_launch,
            label: 'Current Month',
            amount: revenue.currentMonth,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RevenueCard(
            icon: Icons.sailing,
            label: 'Last Month',
            amount: revenue.lastMonth,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RevenueCard(
            icon: Icons.show_chart,
            label: 'Total',
            amount: revenue.total,
          ),
        ),
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;

  const _RevenueCard({
    required this.icon,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E5AA8), Color(0xFF2B6CB8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFFFFD700), size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EnquiryCard extends StatelessWidget {
  final Enquiry enquiry;

  const _EnquiryCard({required this.enquiry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              enquiry.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enquiry.packageName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${enquiry.price}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A90E2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  enquiry.customerName,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFB8C9E8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
