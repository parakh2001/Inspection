class Lead {
  final String carId;
  final String customerId;
  final String evaluatorId;
  final String leadId;
  final String leadRank;
  final String leadStatus;
  final String salespersonId;
  final String operationId;
  final String evaluationTime;
  final String evaluationType;
  final DateTime? evaluationDate; // Nullable since it might be null
  final String customerName;
  final String customerCity;
  final String customerAddress;
  final String customerMobileNumber;
  final String carBuild;
  final String carColor;
  final String carCompany;
  final String carDistanceTravelled;
  final String carFueltype;
  final String carMake;
  final String carModel;
  final String carNumber;
  final String carOwnership;
  final String carCarPrice;
  final String carTransmission;
  final String carVariant;

  Lead({
    required this.carId,
    required this.customerId,
    required this.evaluatorId,
    required this.leadId,
    required this.leadRank,
    required this.leadStatus,
    required this.salespersonId,
    required this.operationId,
    required this.evaluationTime,
    this.evaluationDate, // Allow nullable
    required this.evaluationType,
    required this.customerName,
    required this.customerCity,
    required this.customerAddress,
    required this.customerMobileNumber,
    required this.carBuild,
    required this.carColor,
    required this.carCompany,
    required this.carDistanceTravelled,
    required this.carFueltype,
    required this.carMake,
    required this.carModel,
    required this.carNumber,
    required this.carOwnership,
    required this.carCarPrice,
    required this.carTransmission,
    required this.carVariant,
  });

  factory Lead.fromJson(Map<dynamic, dynamic> leadData,
      Map<dynamic, dynamic> customerData, Map<dynamic, dynamic> carData) {
    return Lead(
      carId: leadData['car_id']?.toString() ?? 'N/A',
      customerId: customerData['customer_id']?.toString() ?? 'N/A',
      evaluatorId: leadData['evaluator_id']?.toString() ?? 'N/A',
      leadId: leadData['lead_id']?.toString() ?? 'N/A',
      leadRank: leadData['lead_rank']?.toString() ?? 'N/A',
      leadStatus: leadData['lead_status']?.toString() ?? 'N/A',
      salespersonId: leadData['salesperson_id']?.toString() ?? 'N/A',
      operationId: leadData['operation_id']?.toString() ?? 'N/A',
      evaluationTime: customerData['evaluation_time']?.toString() ?? 'N/A',
      evaluationDate: _parseEvaluationDate(customerData['evaluation_date']),
      evaluationType: customerData['evaluation_type']?.toString() ?? 'N/A',
      customerName: customerData['name']?.toString() ?? 'N/A',
      customerCity: customerData['city']?.toString() ?? 'N/A',
      customerAddress: customerData['address']?.toString() ?? 'N/A',
      customerMobileNumber: customerData['mobile_number']?.toString() ?? 'N/A',
      carBuild: carData["build"]?.toString() ?? 'N/A',
      carColor: carData["color"]?.toString() ?? 'N/A',
      carCompany: carData["company"]?.toString() ?? 'N/A',
      carDistanceTravelled: carData["distance_travelled"]?.toString() ?? 'N/A',
      carFueltype: carData["fueltype"]?.toString() ?? 'N/A',
      carMake: carData["make"]?.toString() ?? 'N/A',
      carModel: carData["model"]?.toString() ?? 'N/A',
      carNumber: carData["number"]?.toString() ?? 'N/A',
      carOwnership: carData["ownership"]?.toString() ?? 'N/A',
      carCarPrice: carData["car_price"]?.toString() ??
          'N/A', // Fixed typo: car_price instead of car_Price
      carTransmission: carData["transmission"]?.toString() ?? 'N/A',
      carVariant: carData["variant"]?.toString() ?? 'N/A',
    );
  }

  // Helper method to parse the evaluation date safely
  static DateTime? _parseEvaluationDate(dynamic dateData) {
    if (dateData == null) return null;
    if (dateData is String) {
      return DateTime.tryParse(dateData); // Try to parse string to DateTime
    } else if (dateData is int) {
      return DateTime.fromMillisecondsSinceEpoch(
          dateData); // Assume it is a timestamp in milliseconds
    }
    return null;
  }
}
