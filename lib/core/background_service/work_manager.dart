import 'package:uapp/core/background_service/location_worker.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await LocationWorker.updateLocation();
    return Future.value(true);
  });
}