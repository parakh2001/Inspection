class Lead {
  final int serialNumber;
  final String bookingDate;
  final String date;
  final String mobileNumber;
  final String brand;
  final String fuelType;
  final String km;
  final String manfYear;
  final String model;
  final String owner;
  final String rtoLoc;
  final String? sell;
  final String transmission;
  final String variant;
  final String address;
  final String landmark;
  final String? pincode;
  final String state;
  final String userCity;
  final String bookingTime;
  Lead({
    required this.serialNumber,
    required this.bookingDate,
    required this.date,
    required this.mobileNumber,
    required this.brand,
    required this.fuelType,
    required this.km,
    required this.manfYear,
    required this.model,
    required this.owner,
    required this.rtoLoc,
    this.sell,
    required this.transmission,
    required this.variant,
    required this.address,
    required this.landmark,
    this.pincode,
    required this.state,
    required this.userCity,
    required this.bookingTime,
  });

  // Factory method to create a Lead instance from JSON
  factory Lead.fromJson(Map<String, dynamic> leads) {
    return Lead(
      serialNumber: leads['serial_number'] ?? 0,
      bookingDate: leads['booking_date'] ?? '',
      date: leads['date'] ?? '',
      mobileNumber: leads['mobile_number'] ?? '',
      brand: leads['brand'] ?? '',
      fuelType: leads['fuel_type'] ?? '',
      km: leads['km'] ?? '',
      manfYear: leads['manf_year'] ?? '',
      model: leads['model'] ?? '',
      owner: leads['owner'] ?? '',
      rtoLoc: leads['rto_loc'] ?? '',
      sell: leads['sell'],
      transmission: leads['transmission'] ?? '',
      variant: leads['variant'] ?? '',
      address: leads['address'] ?? '',
      landmark: leads['landmark'] ?? '',
      pincode: leads['pincode'],
      state: leads['state'] ?? '',
      userCity: leads['user_city'] ?? '',
      bookingTime: leads['booking_slot'] ?? '',
    );
  }
}
