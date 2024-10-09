class Tasks {
  final String clientName;
  final String clientLocation;
  final String carName;
  final String carNumber;
  final int leadId;
  final DateTime currentDate;
  final DateTime evaluationSlot;
  
  const Tasks({
    required this.clientName,
    required this.clientLocation,
    required this.carName,
    required this.carNumber,
    required this.leadId,
    required this.currentDate,
    required this.evaluationSlot,
  });
}
