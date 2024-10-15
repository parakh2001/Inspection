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
  });
  // Factory method to create a Lead object from Firebase data (Map)
  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      serialNumber: json['serial_number'],
      address: json['address'],
      bookingDate: json['booking_date'],
      bookingSlot: json['booking_slot'],
      brand: json['brand'],
      date: json['date'],
      fuelType: json['fuel_type'],
      km: json['km'],
      landmark: json['landmark'],
      manfYear: json['manf_year'],
      mobileNumber: json['mobile_number'],
      model: json['model'],
      owner: json['owner'],
      pincode: json['pincode'],
      rtoLoc: json['rto_loc'],
      state: json['state'],
      transmission: json['transmission'],
      userCity: json['user_city'],
      variant: json['variant'],
      car_price: json['car_price'],
    );
  }
}
