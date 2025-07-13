import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:itire_prueba_km_bruno/model/get_messages_api_model.dart';
import 'package:itire_prueba_km_bruno/model/get_trips_api_model.dart';
import 'package:itire_prueba_km_bruno/model/login_api_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      body: OutlinedButton(
        onPressed: () async {
          try {
            final dio = Dio();
            String token = dotenv.env['API_TOKEN'] ?? '';
            int vehicleID = 734455;
            final loginResponse = await dio.get(
              "https://hst-api.wialon.com/wialon/ajax.html?svc=token/login&params={\"token\":\"$token\",\"operateAs\":\"SdkDemo\",\"fl\":8}",
            );
            LoginApiModel loginInfo = LoginApiModel.fromMap(loginResponse.data);
            String sessionId = loginInfo.eid;
            final headers = {
              'Content-Type': 'application/x-www-form-urlencoded',
            };
            final paramsForMessages = {
              "itemId": vehicleID,
              "timeFrom": 0,
              "timeTo": (DateTime.now().millisecondsSinceEpoch / 1000).round(),
              "flags": 0,
              "flagsMask": 65280,
              "loadCount": 1,
            };
            final getMessages = await dio.post(
              "https://hst-api.wialon.com/wialon/ajax.html?svc=messages/load_interval&sid=$sessionId&params=${Uri.encodeComponent(json.encode(paramsForMessages))}",
              options: Options(headers: headers),
            );
            if (getMessages.data != null) {
              GetMessagesApiModel messagesData = GetMessagesApiModel.fromMap(
                getMessages.data,
              );
              print("Se cargaron los mensajes $messagesData");
            }
            final paramsForTrips = {
              "itemId": vehicleID,
              "timeFrom": 1700514427,
              "timeTo": (DateTime.now().millisecondsSinceEpoch / 1000).round(),
              "msgsSource": 1,
            };
            final getTrips = await dio.post(
              "https://hst-api.wialon.com/wialon/ajax.html?svc=unit/get_trips&sid=$sessionId&params=${Uri.encodeComponent(json.encode(paramsForTrips))}",
              options: Options(headers: headers),
            );
            if (getTrips.data != null) {
              GetTripsApiModel tripsData = GetTripsApiModel.fromJson(
                json.encode(getTrips.data),
              );
              if (tripsData.trips.isNotEmpty) {
                double totalDistance = 0;
                for (var trip in tripsData.trips) {
                  totalDistance += trip.distance;
                }
                print(
                  "Total distance segun trips = ${(totalDistance / 1000).toStringAsFixed(2)} km",
                );
              } else {
                print("No se encontraron viajes");
              }
            }
          } catch (error) {
            debugPrint('Error: $error');
          }
        },
        child: const Text("API CALL"),
      ),
    );
  }
}
