// import 'package:uapp/core/background_service/location_worker.dart';
// import 'package:uapp/core/background_service/approval_worker.dart';
// import 'package:uapp/core/utils/log.dart';
// import 'package:workmanager/workmanager.dart';


// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     Log.d('WorkManager: Task started - $taskName');
//     try {
//       await LocationWorker.updateLocation();
//     } catch (e) {
//       Log.d('WorkManager: Error in LocationWorker - $e');
//     }

//     try {
//       await ApprovalWorker.checkApprovalData();
//     } catch (e) {
//       Log.d('WorkManager: Error in ApprovalWorker - $e');
//     }

//     Log.d('WorkManager: Task completed - $taskName');
//     return Future.value(true);
//   });
// }

import 'package:uapp/core/background_service/location_worker.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await LocationWorker.updateLocation();
    return Future.value(true);
  });
}