import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itire_prueba_km_bruno/helpers/mileage_storage.dart';
import 'package:itire_prueba_km_bruno/model/get_messages_api_model.dart';
import 'package:itire_prueba_km_bruno/model/get_trips_api_model.dart';
import 'package:itire_prueba_km_bruno/model/login_api_model.dart';

final mileageProvider =
    StateNotifierProvider<MileageNotifier, AsyncValue<double>>(
      (ref) => MileageNotifier(),
    );

class MileageNotifier extends StateNotifier<AsyncValue<double>> {
  final dio = Dio();
  final int _vehicleId = 734455;
  bool _hasBeenCalled = false;
  double _mileage = 0;
  bool _mileageIncreased = false;

  MileageNotifier() : super(AsyncValue.data(0));

  bool get hasBeenCalled => _hasBeenCalled;
  bool get mileageIncreased => _mileageIncreased;

  Future<void> fetchMileage() async {
    state = const AsyncValue.loading();
    try {
      if (_hasBeenCalled) {
        await MileageStorage.setMileage(_mileage);
        _mileageIncreased = false;
      }
      _hasBeenCalled = true;
      final sessionId = await getSessionId(dio);
      int timeFrom = await loadMessages(
        dio: dio,
        sessionId: sessionId,
        vehicleId: _vehicleId,
      );
      _mileage = await getTotalMileage(
        dio: dio,
        sessionId: sessionId,
        vehicleId: _vehicleId,
        timeFrom: timeFrom,
      );
      final savedMileage = await MileageStorage.getMileage();
      if (savedMileage != null && savedMileage != _mileage) {
        _mileageIncreased = true;
      }

      state = AsyncValue.data(_mileage);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

//FUNCTIONS TO CALL THE API
Future<String> getSessionId(Dio dio) async {
  String token = dotenv.env['API_TOKEN'] ?? '';
  final loginResponse = await dio.get(
    "https://hst-api.wialon.com/wialon/ajax.html?svc=token/login&params={\"token\":\"$token\",\"operateAs\":\"SdkDemo\",\"fl\":8}",
  );
  LoginApiModel loginInfo = LoginApiModel.fromMap(loginResponse.data);
  return loginInfo.eid;
}

Future<int> loadMessages({
  required Dio dio,
  required String sessionId,
  required int vehicleId,
}) async {
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  final params = {
    "itemId": vehicleId,
    "timeFrom": 0,
    "timeTo": (DateTime.now().millisecondsSinceEpoch / 1000).round(),
    "flags": 0,
    "flagsMask": 65280,
    "loadCount": 1,
  };

  final messagesResponse = await dio.post(
    "https://hst-api.wialon.com/wialon/ajax.html?svc=messages/load_interval&sid=$sessionId&params=${Uri.encodeComponent(json.encode(params))}",
    options: Options(headers: headers),
  );

  final messagesModel = GetMessagesApiModel.fromMap(messagesResponse.data);
  return messagesModel.messages[0].timestamp;
}

Future<double> getTotalMileage({
  required Dio dio,
  required String sessionId,
  required int vehicleId,
  required int timeFrom,
}) async {
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

  final params = {
    "itemId": vehicleId,
    "timeFrom": timeFrom,
    "timeTo": (DateTime.now().millisecondsSinceEpoch / 1000).round(),
    "msgsSource": 1,
  };

  final getTripsResponse = await dio.post(
    "https://hst-api.wialon.com/wialon/ajax.html?svc=unit/get_trips&sid=$sessionId&params=${Uri.encodeComponent(json.encode(params))}",
    options: Options(headers: headers),
  );

  final tripsData = GetTripsApiModel.fromList(getTripsResponse.data);

  double totalDistance = 0;
  for (var trip in tripsData.trips) {
    totalDistance += trip.distance;
  }

  return totalDistance / 1000;
}
