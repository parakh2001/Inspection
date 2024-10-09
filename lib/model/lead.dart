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
  final String customerName;
  final String customerCity;
  final String customerAddress;
  final String customerMobileNumber;
  final int carBuild;
  final String carColor;
  final String carCompany;
  final num carDistanceTravelled;
  final String carFueltype;
  final String carMake;
  final String carModel;
  final String carNumber;
  final String carOwnership;
  final num carCarPrice;
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
  factory Lead.fromJson(Map<dynamic, dynamic> leadData, Map<dynamic, dynamic> customerData, Map<dynamic, dynamic> carData) {
    return Lead(
      carId: leadData['car_id'] ?? 'N/A',
      customerId: customerData['customer_id'] ?? 'N/A',
      evaluatorId: leadData['evaluator_id'] ?? 'N/A',
      leadId: leadData['lead_id'] ?? 'N/A',
      leadRank: leadData['lead_rank'] ?? 'N/A',
      leadStatus: leadData['lead_status'] ?? 'N/A',
      salespersonId: leadData['salesperson_id'] ?? 'N/A',
      operationId: leadData['operation_id'] ?? 'N/A',
      evaluationTime: customerData['evaluation_time'] ?? 'N/A',
      evaluationType: leadData['evaluation_type'] ?? 'N/A',
      customerName: customerData['name'] ?? 'N/A',
      customerCity: customerData['city'] ?? 'N/A',
      customerAddress: customerData['address'] ?? 'N/A',
      customerMobileNumber: customerData['mobile_number'] ?? 'N/A',
      carBuild: carData["build"] ?? 'N/A',
      carColor: carData["color"] ?? 'N/A',
      carCompany: carData["company"] ?? 'N/A',
      carDistanceTravelled: carData["distance_travelled"] ?? 'N/A',
      carFueltype: carData["fueltype"] ?? 'N/A',
      carMake: carData["make"] ?? 'N/A',
      carModel: carData["model"] ?? 'N/A',
      carNumber: carData["number"] ?? 'N/A',
      carOwnership: carData["ownership"] ?? 'N/A',
      carCarPrice: carData["car_Price"] ?? 'N/A',
      carTransmission: carData["transmission"] ?? 'N/A',
      carVariant: carData["variant"] ?? 'N/A',
    );
  }
}
