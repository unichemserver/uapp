import 'package:uapp/models/to.dart';

class Resi {
  final String nomor;
  final String namaPelanngan;
  final String namaSales;
  final List<To> toItems;

  Resi({
    required this.nomor,
    required this.namaPelanngan,
    required this.namaSales,
    required this.toItems,
  });
}