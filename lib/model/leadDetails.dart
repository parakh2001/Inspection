import '../model/car.dart';
import '../model/customer.dart';
import '../model/lead.dart';
class LeadDetails {
  final Lead lead;
  final Customer customer;
  final Car car;
  LeadDetails({
    required this.lead,
    required this.customer,
    required this.car,
  });
  factory LeadDetails.fromDatabases(Map<String, dynamic> leadData,
      Map<String, dynamic> customerData, Map<String, dynamic> carData) {
    // Fetch lead info
    Lead lead = Lead.fromJson(leadData, customerData, carData);
    // Fetch customer info
    Customer customer = Customer.fromJson(customerData[lead.customerId]);
    // Fetch car info
    Car car = Car.fromJson(carData[lead.carId]);
    return LeadDetails(
      lead: lead,
      customer: customer,
      car: car,
    );
  }
}