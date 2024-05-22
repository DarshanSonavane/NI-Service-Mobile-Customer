class TackComplaintData {
  final String stage;
  final String description;
  final DateTime time;
  final bool isComplete;
  final bool inProgress;

  TackComplaintData({
    required this.stage,
    required this.description,
    required this.time,
    required this.isComplete,
    required this.inProgress
  });
}