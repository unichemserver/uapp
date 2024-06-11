class Customer {
  final int id;
  final String custId;
  final String custName;
  final String address;
  final String phones;
  final String personalName;

  Customer({
    required this.id,
    required this.custId,
    required this.custName,
    required this.address,
    required this.phones,
    required this.personalName,
  });

  factory Customer.fromJson(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      custId: map['CustID'],
      custName: map['custname'],
      address: map['address'],
      phones: map['phones'],
      personalName: map['PersonalName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'CustID': custId,
      'custname': custName,
      'address': address,
      'phones': phones,
      'PersonalName': personalName,
    };
  }
}