import 'dart:convert';

class CarAuction {
  int? auctionCount;
  bool? auctionStatus;
  List<BidUser>? bidUser;
  num? carPrice;
  num? commissionPrice;
  String? companyName;
  // num? customerPrice;
  // num? dealerPrice;
  int? endTime;
  num? engineRating;
  num? highestBid;
  num? maxBidPrice;
  String? id;
  String? imagePath;
  String? rtoNumber;
  List<String>? carImages;
  bool? isOcb;
  bool? isFinalized;
  bool? isPurchased;
  bool? isRcTransfer;
  String? manufacturingYear;
  String? model;
  int? startTime;
  num? totalDistance;
  String? transmission;
  int? coolDownHours;
  String? variant;
  String? clientLocation;

  CarAuction({
    this.auctionCount,
    this.auctionStatus,
    this.bidUser,
    this.carPrice,
    this.commissionPrice,
    this.companyName,
    // this.customerPrice,
    // this.dealerPrice,
    this.endTime,
    this.engineRating,
    this.highestBid,
    this.maxBidPrice,
    this.id,
    this.imagePath,
    this.rtoNumber,
    this.carImages,
    this.isOcb,
    this.isRcTransfer,
    this.manufacturingYear,
    this.model,
    this.startTime,
    this.isPurchased,
    this.isFinalized,
    this.totalDistance,
    this.transmission,
    this.coolDownHours,
    this.variant,
    this.clientLocation,
  });

  CarAuction copyWith({
    int? auctionCount,
    bool? auctionStatus,
    List<BidUser>? bidUser,
    num? carPrice,
    num? commissionPrice,
    String? companyName,
    num? customerPrice,
    num? dealerPrice,
    int? endTime,
    num? engineRating,
    num? highestBid,
    num? maxBidPrice,
    String? id,
    String? imagePath,
    String? rtoNumber,
    List<String>? carImages,
    bool? isOcb,
    bool? isRcTransfer,
    bool? isFinalized,
    bool? isPurchased,
    String? manufacturingYear,
    String? model,
    int? startTime,
    num? totalDistance,
    String? transmission,
    int? coolDownHours,
    String? variant,
    String? clientLocation,
  }) =>
      CarAuction(
        auctionCount: auctionCount ?? this.auctionCount,
        auctionStatus: auctionStatus ?? this.auctionStatus,
        bidUser: bidUser ?? this.bidUser,
        carPrice: carPrice ?? this.carPrice,
        commissionPrice: commissionPrice ?? this.commissionPrice,
        companyName: companyName ?? this.companyName,
        isRcTransfer: isRcTransfer ?? this.isRcTransfer,
        // customerPrice: customerPrice ?? this.customerPrice,
        // dealerPrice: dealerPrice ?? this.dealerPrice,
        endTime: endTime ?? this.endTime,
        rtoNumber: rtoNumber ?? this.rtoNumber,
        engineRating: engineRating ?? this.engineRating,
        highestBid: highestBid ?? this.highestBid,
        maxBidPrice: maxBidPrice ?? this.maxBidPrice,
        id: id ?? this.id,
        isFinalized: isFinalized ?? this.isFinalized,
        isPurchased: isPurchased ?? this.isPurchased,
        imagePath: imagePath ?? this.imagePath,
        carImages: carImages ?? this.carImages,
        isOcb: isOcb ?? this.isOcb,
        manufacturingYear: manufacturingYear ?? this.manufacturingYear,
        model: model ?? this.model,
        startTime: startTime ?? this.startTime,
        totalDistance: totalDistance ?? this.totalDistance,
        transmission: transmission ?? this.transmission,
        coolDownHours: coolDownHours ?? this.coolDownHours,
        variant: variant ?? this.variant,
        clientLocation: clientLocation ?? this.clientLocation,
      );

  factory CarAuction.fromJson(String str) => CarAuction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CarAuction.fromMap(Map<String, dynamic> json) => CarAuction(
        auctionCount: json["auctionCount"],
        auctionStatus: json["auctionStatus"],
        bidUser: json["bidUser"] == null ? [] : List<BidUser>.from(json["bidUser"]!.map((x) => BidUser.fromMap(Map<String, dynamic>.from(x)))),
        carPrice: json["carPrice"] ?? 0.0,
        isPurchased: json["isPurchased"] ?? false,
        isFinalized: json["isFinalized"] ?? false,
        isRcTransfer: json["isRcTransfer"] ?? false,
        commissionPrice: json["commissionPrice"],
        companyName: json["companyName"],
        // customerPrice: json["customerPrice"],
        // dealerPrice: json["dealerPrice"],
        endTime: json["endTime"],
        engineRating: json["engineRating"] ?? 0.0,
        highestBid: json["highestBid"] ?? 0.0,
        maxBidPrice: json["maxBidPrice"] ?? 0.0,
        id: json["id"],
        imagePath: json["imagePath"],
        rtoNumber: json["rtoNumber"],
        clientLocation: json["clientLocation"],
        carImages: json["carImages"] == null ? [] : List<String>.from(json["carImages"]!.map((x) => x)),
        isOcb: json["isOcb"],
        manufacturingYear: json["manufacturingYear"],
        model: json["model"],
        startTime: json["startTime"],
        totalDistance: json["totalDistance"],
        transmission: json["transmission"],
        coolDownHours: json["coolDownHours"],
        variant: json["variant"],
      );

  Map<String, dynamic> toMap() => {
        "auctionCount": auctionCount,
        "auctionStatus": auctionStatus,
        "bidUser": bidUser == null ? [] : List<dynamic>.from(bidUser!.map((x) => x.toMap())),
        "carPrice": carPrice,
        "commissionPrice": commissionPrice,
        "companyName": companyName,
        // "customerPrice": customerPrice,
        // "dealerPrice": dealerPrice,
        "endTime": endTime,
        "isRcTransfer": isRcTransfer,
        "engineRating": engineRating,
        "highestBid": highestBid,
        "rtoNumber": rtoNumber,
        "clientLocation": clientLocation,
        "maxBidPrice": maxBidPrice,
        "isFinalized": isFinalized,
        "isPurchased": isPurchased,
        "id": id,
        "imagePath": imagePath,
        "carImages": carImages == null ? [] : List<dynamic>.from(carImages!.map((x) => x)),
        "isOcb": isOcb,
        "manufacturingYear": manufacturingYear,
        "model": model,
        "startTime": startTime,
        "totalDistance": totalDistance,
        "transmission": transmission,
        "coolDownHours": coolDownHours,
        "variant": variant,
      };
}

class BidUser {
  num? amountIncrease;
  num? currentBid;
  bool? isAutoBid;
  String? userId;
  int? bidTime;

  BidUser({
    this.amountIncrease,
    this.currentBid,
    this.isAutoBid,
    this.userId,
    this.bidTime,
  });

  BidUser copyWith({
    num? amountIncrease,
    num? currentBid,
    bool? isAutoBid,
    String? userId,
    int? bidTime,
  }) =>
      BidUser(
        amountIncrease: amountIncrease ?? this.amountIncrease,
        currentBid: currentBid ?? this.currentBid,
        isAutoBid: isAutoBid ?? this.isAutoBid,
        userId: userId ?? this.userId,
        bidTime: bidTime ?? this.bidTime,
      );

  factory BidUser.fromJson(String str) => BidUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BidUser.fromMap(Map<String, dynamic> json) => BidUser(
        amountIncrease: json["amountIncrease"],
        currentBid: json["currentBid"],
        isAutoBid: json["isAutoBid"],
        userId: json["userId"],
        bidTime: json["bidTime"],
      );

  Map<String, dynamic> toMap() => {
        "amountIncrease": amountIncrease,
        "currentBid": currentBid,
        "isAutoBid": isAutoBid,
        "userId": userId,
        "bidTime": bidTime,
      };
}
