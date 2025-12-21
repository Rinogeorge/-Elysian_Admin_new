class Enquiry {
  final String id;
  final String packageName;
  final int price;
  final String customerName;
  final String imageUrl;

  const Enquiry({
    required this.id,
    required this.packageName,
    required this.price,
    required this.customerName,
    required this.imageUrl,
  });
}