import 'dart:convert';

class Evaluator {
  int? dailyTasks;
  int? evaluatorAge;
  String? evaluatorContactNumber;
  String? evaluatorCurrentLocation;
  String? evaluatorEmail;
  String? evaluatorId;
  List<String>? evaluatorLocation;
  String? evaluatorName;
  int? failedTasks;
  String? flag1;
  String? flag2;
  List<String>? leadId;
  int? monthlyTasks;
  String? totalDistanceCovered;
  int? totalTasks;

  Evaluator({
    this.dailyTasks,
    this.evaluatorAge,
    this.evaluatorContactNumber,
    this.evaluatorCurrentLocation,
    this.evaluatorEmail,
    this.evaluatorId,
    this.evaluatorLocation,
    this.evaluatorName,
    this.failedTasks,
    this.flag1,
    this.flag2,
    this.leadId,
    this.monthlyTasks,
    this.totalDistanceCovered,
    this.totalTasks,
  });

  Evaluator copyWith({
    int? dailyTasks,
    int? evaluatorAge,
    String? evaluatorContactNumber,
    String? evaluatorCurrentLocation,
    String? evaluatorEmail,
    String? evaluatorId,
    List<String>? evaluatorLocation,
    String? evaluatorName,
    int? failedTasks,
    String? flag1,
    String? flag2,
    List<String>? leadId,
    int? monthlyTasks,
    String? totalDistanceCovered,
    int? totalTasks,
  }) =>
      Evaluator(
        dailyTasks: dailyTasks ?? this.dailyTasks,
        evaluatorAge: evaluatorAge ?? this.evaluatorAge,
        evaluatorContactNumber: evaluatorContactNumber ?? this.evaluatorContactNumber,
        evaluatorCurrentLocation: evaluatorCurrentLocation ?? this.evaluatorCurrentLocation,
        evaluatorEmail: evaluatorEmail ?? this.evaluatorEmail,
        evaluatorId: evaluatorId ?? this.evaluatorId,
        evaluatorLocation: evaluatorLocation ?? this.evaluatorLocation,
        evaluatorName: evaluatorName ?? this.evaluatorName,
        failedTasks: failedTasks ?? this.failedTasks,
        flag1: flag1 ?? this.flag1,
        flag2: flag2 ?? this.flag2,
        leadId: leadId ?? this.leadId,
        monthlyTasks: monthlyTasks ?? this.monthlyTasks,
        totalDistanceCovered: totalDistanceCovered ?? this.totalDistanceCovered,
        totalTasks: totalTasks ?? this.totalTasks,
      );

  factory Evaluator.fromJson(String str) => Evaluator.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Evaluator.fromMap(Map<String, dynamic> json) => Evaluator(
        dailyTasks: json["daily_tasks"],
        evaluatorAge: json["evaluator_age"],
        evaluatorContactNumber: json["evaluator_contact_number"].toString(),
        evaluatorCurrentLocation: json["evaluator_current_location"],
        evaluatorEmail: json["evaluator_email"],
        evaluatorId: json["evaluator_id"],
        evaluatorLocation: json["evaluator_location"] == null ? [] : List<String>.from(json["evaluator_location"]!.map((x) => x)),
        evaluatorName: json["evaluator_name"],
        failedTasks: json["failed_tasks"],
        flag1: json["flag-1"],
        flag2: json["flag-2"],
        leadId: json["lead_id"] == null ? [] : List<String>.from(json["lead_id"]!.map((x) => x)),
        monthlyTasks: json["monthly_tasks"],
        totalDistanceCovered: json["total_distance_covered"],
        totalTasks: json["total_tasks"],
      );

  Map<String, dynamic> toMap() => {
        "daily_tasks": dailyTasks,
        "evaluator_age": evaluatorAge,
        "evaluator_contact_number": evaluatorContactNumber,
        "evaluator_current_location": evaluatorCurrentLocation,
        "evaluator_email": evaluatorEmail,
        "evaluator_id": evaluatorId,
        "evaluator_location": evaluatorLocation == null ? [] : List<dynamic>.from(evaluatorLocation!.map((x) => x)),
        "evaluator_name": evaluatorName,
        "failed_tasks": failedTasks,
        "flag-1": flag1,
        "flag-2": flag2,
        "lead_id": leadId == null ? [] : List<dynamic>.from(leadId!.map((x) => x)),
        "monthly_tasks": monthlyTasks,
        "total_distance_covered": totalDistanceCovered,
        "total_tasks": totalTasks,
      };
}
