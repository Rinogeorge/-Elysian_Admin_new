import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PriceDoesNotIncludes extends StatelessWidget {
  final List<String> items;
  const PriceDoesNotIncludes({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 250, // Remove fixed height
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color.fromARGB(255, 243, 171, 171),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 5),
          Text(
            "What's excluded from the tour price",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.close, size: 16, color: Colors.red[800]),
                  SizedBox(width: 8),
                  Expanded(child: Text(item, style: TextStyle(fontSize: 14))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
