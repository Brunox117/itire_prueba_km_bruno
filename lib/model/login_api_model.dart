import 'dart:convert';

class LoginApiModel {
  String host;
  String eid;
  String gisSid;
  String au;
  int tm;
  String wsdkVersion;
  String baseUrl;
  String hwGwIp;
  String hwGwDns;
  String gisSearch;
  String gisRender;
  String gisGeocode;
  String gisRouting;
  String billingByCodes;
  Map<String, int> classes;
  String videoServiceUrl;

  LoginApiModel({
    required this.host,
    required this.eid,
    required this.gisSid,
    required this.au,
    required this.tm,
    required this.wsdkVersion,
    required this.baseUrl,
    required this.hwGwIp,
    required this.hwGwDns,
    required this.gisSearch,
    required this.gisRender,
    required this.gisGeocode,
    required this.gisRouting,
    required this.billingByCodes,
    required this.classes,
    required this.videoServiceUrl,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'host': host});
    result.addAll({'eid': eid});
    result.addAll({'gisSid': gisSid});
    result.addAll({'au': au});
    result.addAll({'tm': tm});
    result.addAll({'wsdkVersion': wsdkVersion});
    result.addAll({'baseUrl': baseUrl});
    result.addAll({'hwGwIp': hwGwIp});
    result.addAll({'hwGwDns': hwGwDns});
    result.addAll({'gisSearch': gisSearch});
    result.addAll({'gisRender': gisRender});
    result.addAll({'gisGeocode': gisGeocode});
    result.addAll({'gisRouting': gisRouting});
    result.addAll({'billingByCodes': billingByCodes});
    result.addAll({'classes': classes});
    result.addAll({'videoServiceUrl': videoServiceUrl});

    return result;
  }

  factory LoginApiModel.fromMap(Map<String, dynamic> map) {
    return LoginApiModel(
      host: map['host'] ?? '',
      eid: map['eid'] ?? '',
      gisSid: map['gisSid'] ?? '',
      au: map['au'] ?? '',
      tm: map['tm']?.toInt() ?? 0,
      wsdkVersion: map['wsdkVersion'] ?? '',
      baseUrl: map['baseUrl'] ?? '',
      hwGwIp: map['hwGwIp'] ?? '',
      hwGwDns: map['hwGwDns'] ?? '',
      gisSearch: map['gisSearch'] ?? '',
      gisRender: map['gisRender'] ?? '',
      gisGeocode: map['gisGeocode'] ?? '',
      gisRouting: map['gisRouting'] ?? '',
      billingByCodes: map['billingByCodes'] ?? '',
      classes: Map<String, int>.from(map['classes']),
      videoServiceUrl: map['videoServiceUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginApiModel.fromJson(String source) =>
      LoginApiModel.fromMap(json.decode(source));
}
