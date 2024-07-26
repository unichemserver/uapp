class BarangBalance {
  final String itemid;
  final String descitem;

  BarangBalance({
    required this.itemid,
    required this.descitem,
  });

  factory BarangBalance.fromJson(Map<String, dynamic> json) {
    return BarangBalance(
      itemid: json['itemid'],
      descitem: json['descitem'],
    );
  }
}