class Customer {
  final String customerId;
  final String name;
  final String city;
  final String address;
  final String mobileNumber;
  final String evaluationDate;
  final String evaluationTime;

  Customer({
    required this.customerId,
    required this.name,
    required this.city,
    required this.address,
    required this.mobileNumber,
    required this.evaluationDate,
    required this.evaluationTime,
  });

  factory Customer.fromJson(Map<String, dynamic> customerData) {
    return Customer(
      customerId: customerData['customer_id'] ?? 'N/A',
      name: customerData['name'] ?? 'N/A',
      city: customerData['city'] ?? 'N/A',
      address: customerData['address'] ?? 'N/A',
      mobileNumber: customerData['mobile_number'] ?? 'N/A',
      evaluationDate: customerData['evaluation_date'] ?? 'N/A',
      evaluationTime: customerData['evaluation_time'] ?? 'N/A',
    );
  }
}
