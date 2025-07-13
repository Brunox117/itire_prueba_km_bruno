import 'dart:convert';

class GetTripsApiModel {
  List<Trip> trips;

  GetTripsApiModel({required this.trips});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'trips': trips.map((x) => x.toMap()).toList()});

    return result;
  }

  factory GetTripsApiModel.fromMap(Map<String, dynamic> map) {
    return GetTripsApiModel(
      trips: List<Trip>.from(map['trips']?.map((x) => Trip.fromMap(x)) ?? []),
    );
  }

  factory GetTripsApiModel.fromList(List<dynamic> list) {
    return GetTripsApiModel(
      trips: List<Trip>.from(list.map((x) => Trip.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetTripsApiModel.fromJson(String source) {
    final decoded = json.decode(source);
    if (decoded is List) {
      return GetTripsApiModel.fromList(decoded);
    } else if (decoded is Map<String, dynamic>) {
      return GetTripsApiModel.fromMap(decoded);
    } else {
      throw FormatException('Invalid JSON format for GetTripsApiModel');
    }
  }
}

class Trip {
  TripPoint from;
  TripPoint to;
  double distance;

  Trip({required this.from, required this.to, required this.distance});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'from': from.toMap()});
    result.addAll({'to': to.toMap()});
    result.addAll({'m': distance});

    return result;
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      from: TripPoint.fromMap(map['from']),
      to: TripPoint.fromMap(map['to']),
      distance: (map['m'] ?? 0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Trip.fromJson(String source) => Trip.fromMap(json.decode(source));
}

class TripPoint {
  int id;
  int timestamp;
  TripPosition position;

  TripPoint({
    required this.id,
    required this.timestamp,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'i': id});
    result.addAll({'t': timestamp});
    result.addAll({'p': position.toMap()});

    return result;
  }

  factory TripPoint.fromMap(Map<String, dynamic> map) {
    return TripPoint(
      id: map['i']?.toInt() ?? 0,
      timestamp: map['t']?.toInt() ?? 0,
      position: TripPosition.fromMap(map['p']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TripPoint.fromJson(String source) =>
      TripPoint.fromMap(json.decode(source));
}

class TripPosition {
  double latitude;
  double longitude;

  TripPosition({required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'y': latitude});
    result.addAll({'x': longitude});

    return result;
  }

  factory TripPosition.fromMap(Map<String, dynamic> map) {
    return TripPosition(
      latitude: (map['y'] ?? 0).toDouble(),
      longitude: (map['x'] ?? 0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TripPosition.fromJson(String source) =>
      TripPosition.fromMap(json.decode(source));
}
