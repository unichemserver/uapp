import 'package:uapp/modules/marketing/model/to_model.dart';

class Resi {
  final String activity;
  final String nomor;
  final String namaPelanngan;
  final String namaSales;
  final List<ToModel> toItems;

  Resi({
    required this.activity,
    required this.nomor,
    required this.namaPelanngan,
    required this.namaSales,
    required this.toItems,
  });
}