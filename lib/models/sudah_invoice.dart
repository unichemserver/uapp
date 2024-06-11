class SudahInvoice {
  final String custID;
  final String custname;
  final String noinv;
  final dynamic amount;
  final dynamic amountpaid;
  final dynamic discrepancy;
  final String currencyID;
  final String duedate;

  SudahInvoice({
    required this.custID,
    required this.custname,
    required this.noinv,
    required this.amount,
    required this.amountpaid,
    required this.discrepancy,
    required this.currencyID,
    required this.duedate,
  });

  factory SudahInvoice.fromJson(Map<String, dynamic> json) {
    return SudahInvoice(
      custID: json['custID'],
      custname: json['custname'],
      noinv: json['noinv'],
      amount: json['amount'],
      amountpaid: json['amountpaid'],
      discrepancy: json['discrepancy'],
      currencyID: json['currencyID'],
      duedate: json['duedate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custID': custID,
      'custname': custname,
      'noinv': noinv,
      'amount': amount,
      'amountpaid': amountpaid,
      'discrepancy': discrepancy,
      'currencyID': currencyID,
      'duedate': duedate,
    };
  }
}