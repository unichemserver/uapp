class CustSybase {
  final String custID;
  final String custname;
  final String description;
  final String taxid;
  final String groupaId;
  
  CustSybase({
    required this.custID,
    required this.custname,
    required this.description,
    required this.taxid,
    required this.groupaId,
  });

  factory CustSybase.fromJson(Map<String, dynamic> json) {
    return CustSybase(
      custID: json['CustID'] ?? '',
      custname: json['custname'] ?? '',
      description: json['Description'] ?? '',
      taxid: json['taxid'] ?? '',
      groupaId: json['groupa_id'] ?? '',
    );
  }
}
