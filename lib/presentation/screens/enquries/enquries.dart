
import 'package:elysian_admin/features/entity/enquries.dart';
import 'package:flutter/material.dart';

class EnquriesPage extends StatelessWidget {
  const EnquriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data - in real app, this would come from a repository
    final enquiries = [
      const Enquiry(
        id: '1',
        packageName: 'Beautiful Thailand',
        price: 50000,
        customerName: 'Sreejith P',
        imageUrl: 'assets/thailand1.jpg',
      ),
      const Enquiry(
        id: '2',
        packageName: 'Simply Thailand',
        price: 165000,
        customerName: 'Sreejith P',
        imageUrl: 'assets/thailand2.jpg',
      ),
      const Enquiry(
        id: '3',
        packageName: 'Wonders of france',
        price: 165000,
        customerName: 'Sreejith P',
        imageUrl: 'assets/france.jpg',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Enquiries',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: enquiries.length,
        itemBuilder: (context, index) {
          return EnquiryCard(
            enquiry: enquiries[index],
            isHighlighted: index == 0,
            onAccept: () => _handleAccept(context, enquiries[index]),
            onCancel: () => _handleCancel(context, enquiries[index]),
          );
        },
      ),
    );
  }

  void _handleAccept(BuildContext context, Enquiry enquiry) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted: ${enquiry.packageName}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleCancel(BuildContext context, Enquiry enquiry) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cancelled: ${enquiry.packageName}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Presentation Layer - Enquiry Card Widget
class EnquiryCard extends StatelessWidget {
  final Enquiry enquiry;
  final bool isHighlighted;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  const EnquiryCard({
    Key? key,
    required this.enquiry,
    required this.isHighlighted,
    required this.onAccept,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? Border.all(color: Colors.blue, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey,
                    ),
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
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${enquiry.price} INR',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Customer name : ${enquiry.customerName}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF90EE90),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB6B6),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
