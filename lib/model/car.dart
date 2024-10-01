class Car {
  final String carId;
  final String make;
  final String model;
  final String variant;
  final String fuelType;
  final String transmission;
  final String company;
  final String number;

  Car({
    required this.carId,
    required this.make,
    required this.model,
    required this.variant,
    required this.fuelType,
    required this.transmission,
    required this.company,
    required this.number,
  });

  factory Car.fromJson(Map<String, dynamic> carData) {
    return Car(
      carId: carData['car_id'] ?? 'N/A',
      make: carData['make'] ?? 'N/A',
      model: carData['model'] ?? 'N/A',
      variant: carData['variant'] ?? 'N/A',
      fuelType: carData['fueltype'] ?? 'N/A',
      transmission: carData['transmission'] ?? 'N/A',
      company: carData['company'] ?? 'N/A',
      number: carData['number'] ?? 'N/A',
    );
  }
}
