import 'dart:convert';

class Car {
  int? build;
  String? carId;
  String? color;
  String? company;
  num? distanceTravelled;
  String? fueltype;
  String? make;
  String? model;
  String? number;
  String? ownership;
  num? carPrice;
  String? transmission;
  String? variant;

  Car({
    this.build,
    this.carId,
    this.color,
    this.company,
    this.distanceTravelled,
    this.fueltype,
    this.make,
    this.model,
    this.number,
    this.ownership,
    this.carPrice,
    this.transmission,
    this.variant,
  });

  Car copyWith({
    int? build,
    String? carId,
    String? color,
    String? company,
    num? distanceTravelled,
    String? fueltype,
    String? make,
    String? model,
    String? number,
    String? ownership,
    num? carPrice,
    String? transmission,
    String? variant,
  }) =>
      Car(
        build: build ?? this.build,
        carId: carId ?? this.carId,
        color: color ?? this.color,
        company: company ?? this.company,
        distanceTravelled: distanceTravelled ?? this.distanceTravelled,
        fueltype: fueltype ?? this.fueltype,
        make: make ?? this.make,
        model: model ?? this.model,
        number: number ?? this.number,
        ownership: ownership ?? this.ownership,
        carPrice: carPrice ?? this.carPrice,
        transmission: transmission ?? this.transmission,
        variant: variant ?? this.variant,
      );

  factory Car.fromJson(String str) => Car.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Car.fromMap(Map<String, dynamic> json) => Car(
        build: json["build"] ?? 'N/A',
        carId: json["car_id"] ?? 'N/A',
        color: json["color"] ?? 'N/A',
        company: json["company"] ?? 'N/A',
        distanceTravelled: json["distance_travelled"] ?? 'N/A',
        fueltype: json["fueltype"] ?? 'N/A',
        make: json["make"] ?? 'N/A',
        model: json["model"] ?? 'N/A',
        number: json["number"] ?? 'N/A',
        ownership: json["ownership"] ?? 'N/A',
        carPrice: json["car_Price"] ?? 'N/A',
        transmission: json["transmission"] ?? 'N/A',
        variant: json["variant"] ?? 'N/A',
      );

  Map<String, dynamic> toMap() => {
        "build": build,
        "car_id": carId,
        "color": color,
        "company": company,
        "distance_travelled": distanceTravelled,
        "fueltype": fueltype,
        "make": make,
        "model": model,
        "number": number,
        "ownership": ownership,
        "car_Price": carPrice,
        "transmission": transmission,
        "variant": variant,
      };
}
