import 'package:flutter/cupertino.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class GroupModel {
  final String id;
  final String groupTitle;
  final String collectorName;
  final String collectorPhone;
  final String address;
  final String? imageUrl;

  final int clientsCount;
  final int dueCount;
  final int dueTodayCount;
  final int overdueCount;
  final int completedCount;

  final double totalValue;
  final double collectedValue;
  final double remainingValue;

  // Current month's statistics.
  final String currentMonthKey;
  final double monthTarget;
  final double monthCollection;

  // Historical monthly statistics, keyed by yyyy-MM.
  final Map<String, dynamic> monthlyStats;

  const GroupModel({
    this.id = '',
    required this.groupTitle,
    required this.collectorName,
    required this.collectorPhone,
    this.address = '',
    this.imageUrl,
    this.clientsCount = 0,
    this.dueCount = 0,
    this.dueTodayCount = 0,
    this.overdueCount = 0,
    this.completedCount = 0,
    this.totalValue = 0,
    this.collectedValue = 0,
    this.remainingValue = 0,
    this.currentMonthKey = '',
    this.monthTarget = 0,
    this.monthCollection = 0,
    this.monthlyStats = const {},
  });

  double get progress {
    if (totalValue <= 0) return 0;
    return (collectedValue / totalValue).clamp(0.0, 1.0);
  }

  double get monthProgress {
    if (monthTarget <= 0) return 0;
    return (monthCollection / monthTarget).clamp(0.0, 1.0);
  }

  String status(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (clientsCount > 0 && completedCount == clientsCount) {
      return l10n.paid;
    }

    if (overdueCount > 0) return l10n.overdue;
    if (dueTodayCount > 0) return l10n.due;
    return l10n.unpaid;
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
      'dueTodayCount': dueTodayCount,
      'overdueCount': overdueCount,
      'completedCount': completedCount,
      'totalValue': totalValue,
      'collectedValue': collectedValue,
      'remainingValue': remainingValue,
      'currentMonthKey': currentMonthKey,
      'monthTarget': monthTarget,
      'monthCollection': monthCollection,
      'monthlyStats': monthlyStats,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map, {required String id}) {
    final rawMonthlyStats = map['monthlyStats'];
    final Map<String, dynamic> parsedMonthlyStats = rawMonthlyStats is Map
        ? Map<String, dynamic>.from(rawMonthlyStats)
        : <String, dynamic>{};

    return GroupModel(
      id: id,
      groupTitle: map['groupTitle'] as String? ?? '',
      collectorName: map['collectorName'] as String? ?? '',
      collectorPhone: map['collectorPhone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      clientsCount: (map['clientsCount'] as num?)?.toInt() ?? 0,
      dueCount: (map['dueCount'] as num?)?.toInt() ?? 0,
      dueTodayCount: (map['dueTodayCount'] as num?)?.toInt() ?? 0,
      overdueCount: (map['overdueCount'] as num?)?.toInt() ?? 0,
      completedCount: (map['completedCount'] as num?)?.toInt() ?? 0,
      totalValue: (map['totalValue'] as num?)?.toDouble() ?? 0,
      collectedValue: (map['collectedValue'] as num?)?.toDouble() ?? 0,
      remainingValue: (map['remainingValue'] as num?)?.toDouble() ?? 0,
      currentMonthKey: map['currentMonthKey']?.toString() ?? '',
      monthTarget: (map['monthTarget'] as num?)?.toDouble() ?? 0,
      monthCollection: (map['monthCollection'] as num?)?.toDouble() ?? 0,
      monthlyStats: parsedMonthlyStats,
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
    int? dueTodayCount,
    int? overdueCount,
    int? completedCount,
    double? totalValue,
    double? collectedValue,
    double? remainingValue,
    String? currentMonthKey,
    double? monthTarget,
    double? monthCollection,
    Map<String, dynamic>? monthlyStats,
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
      dueTodayCount: dueTodayCount ?? this.dueTodayCount,
      overdueCount: overdueCount ?? this.overdueCount,
      completedCount: completedCount ?? this.completedCount,
      totalValue: totalValue ?? this.totalValue,
      collectedValue: collectedValue ?? this.collectedValue,
      remainingValue: remainingValue ?? this.remainingValue,
      currentMonthKey: currentMonthKey ?? this.currentMonthKey,
      monthTarget: monthTarget ?? this.monthTarget,
      monthCollection: monthCollection ?? this.monthCollection,
      monthlyStats: monthlyStats ?? this.monthlyStats,
    );
  }
}
