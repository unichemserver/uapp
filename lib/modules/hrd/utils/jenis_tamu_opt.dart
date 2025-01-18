class JenisTamu {
  final String title;
  final String method;

  JenisTamu({required this.title, required this.method});
}

List<JenisTamu> jenisTamuList = [
  JenisTamu(title: 'Tamu Terencana', method: 'get_tamu_terencana'),
  JenisTamu(title: 'Tamu Insidentil', method: 'get_tamu_insidentil'),
  JenisTamu(title: 'Tamu Dengan PO', method: 'get_tamu_po'),
  JenisTamu(title: 'Tamu Dengan SO', method: 'get_tamu_so'),
  JenisTamu(title: 'Tamu Dengan LTO', method: 'get_tamu_lto'),
  JenisTamu(title: 'Tamu Dengan RO', method: 'get_tamu_ro'),
];