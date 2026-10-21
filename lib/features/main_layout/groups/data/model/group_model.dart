
class GroupModel {
  final String id;
  final String groupTitle;
  final String collectorName;
  final String collectorPhone;
  final String address;
  final String? imageUrl;
  final int clientsCount;
  final int dueCount;
  final double totalValue;
  final double collectedValue;
  final double remainingValue;

  const GroupModel({
    this.id = '',
    required this.groupTitle,
    required this.collectorName,
    required this.collectorPhone,
    this.address = '',
    this.imageUrl,
    this.clientsCount = 0,
    this.dueCount = 0,
    this.totalValue = 0,
    this.collectedValue = 0,
    this.remainingValue = 0,
  });

  double get progress {
    if (totalValue <= 0) return 0;
    return (collectedValue / totalValue).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toMap() {
    return {
      'groupTitle': groupTitle,
      'collectorName': collectorName,
      'collectorPhone': collectorPhone,
      'address': address,
      'imageUrl': imageUrl,
      'clientsCount': clientsCount,
      'dueCount': dueCount,
      'totalValue': totalValue,
      'collectedValue': collectedValue,
      'remainingValue': remainingValue,
    };
  }

  factory GroupModel.fromMap(
      Map<String, dynamic> map, {
        required String id,
      }) {
    return GroupModel(
      id: id,
      groupTitle: map['groupTitle'] as String? ?? '',
      collectorName: map['collectorName'] as String? ?? '',
      collectorPhone: map['collectorPhone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      clientsCount: (map['clientsCount'] as num?)?.toInt() ?? 0,
      dueCount: (map['dueCount'] as num?)?.toInt() ?? 0,
      totalValue: (map['totalValue'] as num?)?.toDouble() ?? 0,
      collectedValue:
      (map['collectedValue'] as num?)?.toDouble() ?? 0,
      remainingValue:
      (map['remainingValue'] as num?)?.toDouble() ?? 0,
    );
  }

  GroupModel copyWith({
    String? id,
    String? groupTitle,
    String? collectorName,
    String? collectorPhone,
    String? address,
    String? imageUrl,
    int? clientsCount,
    int? dueCount,
    double? totalValue,
    double? collectedValue,
    double? remainingValue,
  }) {
    return GroupModel(
      id: id ?? this.id,
      groupTitle: groupTitle ?? this.groupTitle,
      collectorName: collectorName ?? this.collectorName,
      collectorPhone: collectorPhone ?? this.collectorPhone,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      clientsCount: clientsCount ?? this.clientsCount,
      dueCount: dueCount ?? this.dueCount,
      totalValue: totalValue ?? this.totalValue,
      collectedValue: collectedValue ?? this.collectedValue,
      remainingValue: remainingValue ?? this.remainingValue,
    );
  }
}
