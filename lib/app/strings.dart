class Strings {
  static const String appTitle = 'U-APP';
  static const String login = 'Masuk';
  static const String removeBgAPIKey = 'rDCSbEdJsbe4GSPK8g732Ckb';

  static String toTitleWord(String input) {
    if (input.isEmpty) {
      return input;
    }
    List<String> words = input.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    return capitalizedWords.join(' ');
  }
}