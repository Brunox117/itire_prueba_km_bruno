import 'dart:convert';

class GetMessagesApiModel {
  int count;
  List<Message> messages;

  GetMessagesApiModel({required this.count, required this.messages});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'count': count});
    result.addAll({'messages': messages.map((x) => x.toMap()).toList()});

    return result;
  }

  factory GetMessagesApiModel.fromMap(Map<String, dynamic> map) {
    return GetMessagesApiModel(
      count: map['count']?.toInt() ?? 0,
      messages: List<Message>.from(
        map['messages']?.map((x) => Message.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetMessagesApiModel.fromJson(String source) =>
      GetMessagesApiModel.fromMap(json.decode(source));
}

class Message {
  int timestamp;
  int flag;
  String type;
  Position position;
  int locationCode;
  int responseTime;
  Map<String, dynamic> properties;

  Message({
    required this.timestamp,
    required this.flag,
    required this.type,
    required this.position,
    required this.locationCode,
    required this.responseTime,
    required this.properties,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'t': timestamp});
    result.addAll({'f': flag});
    result.addAll({'tp': type});
    result.addAll({'pos': position.toMap()});
    result.addAll({'lc': locationCode});
    result.addAll({'rt': responseTime});
    result.addAll({'p': properties});

    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      timestamp: map['t']?.toInt() ?? 0,
      flag: map['f']?.toInt() ?? 0,
      type: map['tp'] ?? '',
      position: Position.fromMap(map['pos']),
      locationCode: map['lc']?.toInt() ?? 0,
      responseTime: map['rt']?.toInt() ?? 0,
      properties: Map<String, dynamic>.from(map['p'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));
}

class Position {
  double y;
  double x;
  int color;
  int z;
  int scale;
  int scaleColor;

  Position({
    required this.y,
    required this.x,
    required this.color,
    required this.z,
    required this.scale,
    required this.scaleColor,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'y': y});
    result.addAll({'x': x});
    result.addAll({'c': color});
    result.addAll({'z': z});
    result.addAll({'s': scale});
    result.addAll({'sc': scaleColor});

    return result;
  }

  factory Position.fromMap(Map<String, dynamic> map) {
    return Position(
      y: map['y']?.toDouble() ?? 0.0,
      x: map['x']?.toDouble() ?? 0.0,
      color: map['c']?.toInt() ?? 0,
      z: map['z']?.toInt() ?? 0,
      scale: map['s']?.toInt() ?? 0,
      scaleColor: map['sc']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Position.fromJson(String source) =>
      Position.fromMap(json.decode(source));
}
