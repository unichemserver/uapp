import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/utils/date_utils.dart';
import 'package:uapp/core/utils/utils.dart';

class MktUtils {

  Future<String> generateMarketingActivityID() async {
    final db = MarketingDatabase();
    var dateToday = DateUtils.getFormatDate();
    var userId = Utils.getUserData().id;
    String pattern = 'CM$userId$dateToday';
    String query = '''
    SELECT id FROM marketing_activity
      WHERE id LIKE '$pattern%'
      ORDER BY created_at DESC
      LIMIT 1
    ''';
    List<Map> result = await db.rawQuery(query);
    int newIncrement = 1;
    if (result.isNotEmpty) {
      String lastId = result.first['id'];
      int lastIncrement = int.parse(lastId.substring(lastId.length - 3));
      newIncrement = lastIncrement + 1;
    }
    return '$pattern${newIncrement.toString().padLeft(3, '0')}';
  }
}