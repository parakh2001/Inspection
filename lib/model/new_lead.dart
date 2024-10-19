class Lead {
  final int serialNumber;
  final String address;
  final String bookingDate;
  final String bookingSlot;
  final String brand;
  final String date;
  final String fuelType;
  final String km;
  final String landmark;
  final String manfYear;
  final String mobileNumber;
  final String model;
  final String owner;
  final String pincode;
  final String rtoLoc;
  final String state;
  final String transmission;
  final String userCity;
  final String variant;
  final String car_price;
  final int leadStatus;

  Lead({
    required this.serialNumber,
    required this.address,
    required this.bookingDate,
    required this.bookingSlot,
    required this.brand,
    required this.date,
    required this.fuelType,
    required this.km,
    required this.landmark,
    required this.manfYear,
    required this.mobileNumber,
    required this.model,
    required this.owner,
    required this.pincode,
    required this.rtoLoc,
    required this.state,
    required this.transmission,
    required this.userCity,
    required this.variant,
    required this.car_price,
    required this.leadStatus,
  });
  // Factory method to create a Lead object from Firebase data (Map)
  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      serialNumber:
          json['serial_number'] ?? 0, // Provide a default value if null
      address: json['address'] ?? '', // Default empty string
      bookingDate: json['booking_date'] ?? '', // Default empty string
      bookingSlot: json['booking_slot'] ?? '', // Default empty string
      brand: json['brand'] ?? '', // Default empty string
      date: json['date'] ?? '', // Default empty string
      fuelType: json['fuel_type'] ?? '', // Default empty string
      km: json['km'] ?? '', // Default empty string
      landmark: json['landmark'] ?? '', // Default empty string
      manfYear: json['manf_year'] ?? '', // Default empty string
      mobileNumber: json['mobile_number'] ?? '', // Default empty string
      model: json['model'] ?? '', // Default empty string
      owner: json['owner'] ?? '', // Default empty string
      pincode: json['pincode'] ?? '', // Default empty string
      rtoLoc: json['rto_loc'] ?? '', // Default empty string
      state: json['state'] ?? '', // Default empty string
      transmission: json['transmission'] ?? '', // Default empty string
      userCity: json['user_city'] ?? '', // Default empty string
      variant: json['variant'] ?? '', // Default empty string
      car_price: json['car_price'] ?? '', // Default empty string
      leadStatus: json['leadStatus'] ?? 0, // Provide a default value if null
    );
  }
}
