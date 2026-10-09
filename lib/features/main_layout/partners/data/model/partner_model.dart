enum PartnerType {admin, primary, secondary,  }

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

  bool get isPrimary => type == PartnerType.primary;
  bool get isAdmin => type == PartnerType.admin;

  double get newCapital => mainCapital + (mainCapital * (profitMargin / 100));
}