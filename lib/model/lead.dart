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
  final String carNumber;
  final String carModel;
  final String carVariant;
  final String carFuelType;
  final String carTransmission;
  final String carCompany;
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
    required this.carNumber,
    required this.carModel,
    required this.carVariant,
    required this.carFuelType,
    required this.carTransmission,
    required this.carCompany,
  });
  factory Lead.fromJson(Map<String, dynamic> leadData,
      Map<dynamic, dynamic> customerData, Map<dynamic, dynamic> carData) {
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
      carNumber: carData['number'] ?? 'N/A',
      carModel: carData['model'] ?? 'N/A',
      carVariant: carData['variant'] ?? 'N/A',
      carFuelType: carData['fueltype'] ?? 'N/A',
      carTransmission: carData['transmission'] ?? 'N/A',
      carCompany: carData['company'] ?? 'N/A',
    );
  }
}
