enum PartnerType { admin, primary, secondary }

class PartnerModel {
  final String id;
  final String name;
  final String? imagePath;
  final String address;
  final String phone;
  final double mainCapital;
  final double profitMargin;
  final PartnerType type;

  const PartnerModel({
    required this.id,
    required this.name,
    this.imagePath,
    required this.address,
    required this.phone,
    required this.mainCapital,
    required this.profitMargin,
    this.type = PartnerType.primary,
  });

  bool get isAdmin => type == PartnerType.admin;

  bool get isPrimary => type == PartnerType.primary;

  bool get isSecondary => type == PartnerType.secondary;

  double get newCapital {
    return mainCapital + (mainCapital * profitMargin / 100);
  }

  PartnerModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    bool clearImagePath = false,
    String? address,
    String? phone,
    double? mainCapital,
    double? profitMargin,
    PartnerType? type,
  }) {
    return PartnerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: clearImagePath ? null : imagePath ?? this.imagePath,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      mainCapital: mainCapital ?? this.mainCapital,
      profitMargin: profitMargin ?? this.profitMargin,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'address': address,
      'phone': phone,
      'mainCapital': mainCapital,
      'profitMargin': profitMargin,
      'partnerType': type.name,
    };
  }

  factory PartnerModel.fromMap(Map<String, dynamic> map, {required String id}) {
    PartnerType parsedType = PartnerType.primary;

    final typeValue = map['partnerType'] ?? map['partner_type'];

    for (final type in PartnerType.values) {
      if (type.name == typeValue) {
        parsedType = type;
        break;
      }
    }

    return PartnerModel(
      id: id,
      name: map['name']?.toString() ?? '',
      imagePath: map['imagePath']?.toString(),
      address: map['address']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      mainCapital: _toDouble(map['mainCapital']),
      profitMargin: _toDouble(map['profitMargin']),
      type: parsedType,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
