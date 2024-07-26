Map<String, dynamic> instances = {
  'Unichem': 'https://unichem.co.id/api/index.php',
  'Unifood': 'https://unifood.id/api/index.php',
};

String getBaseImageUrl(String baseUrl, String type, String fileName) {
  var host = baseUrl.replaceAll('api/index.php', '');
  switch (type) {
    case 'sjtm':
      return '$host/EDS/upload/dokumenkaryawan/DokumenIjinPribadi/$fileName';
    default:
      return '';
  }
}
