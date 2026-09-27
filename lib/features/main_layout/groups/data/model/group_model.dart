class GroupModel {
  final String groupTitle;
  final String collectorName;
  final String collectorPhone;
  final int clientsCount;
  final int dueCount;
  final double totalValue;
  final double collectedValue;
  final double remainingValue;

  const GroupModel({
    required this.groupTitle,
    required this.collectorName,
    required this.collectorPhone,
    required this.clientsCount,
    required this.dueCount,
    required this.totalValue,
    required this.collectedValue,
    required this.remainingValue,
  });

  double get progress {
    if (totalValue <= 0) return 0;
    return collectedValue / totalValue;
  }
}