// To parse this JSON data, do
//
//     final place = placeFromJson(jsonString);

import 'dart:convert';

Place placeFromJson(String str) => Place.fromJson(json.decode(str));

String placeToJson(Place data) => json.encode(data.toJson());

class Place {
  final List<Feature>? features;

  Place({
    this.features,
  });

  Place copyWith({
    List<Feature>? features,
  }) =>
      Place(
        features: features ?? this.features,
      );

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        features: json["features"] == null
            ? []
            : List<Feature>.from(
                json["features"]!.map((x) => Feature.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "features": features == null
            ? []
            : List<dynamic>.from(features!.map((x) => x.toJson())),
      };
}

class Feature {
  final Geometry? geometry;
  final String? type;
  final Properties? properties;

  Feature({
    this.geometry,
    this.type,
    this.properties,
  });

  Feature copyWith({
    Geometry? geometry,
    String? type,
    Properties? properties,
  }) =>
      Feature(
        geometry: geometry ?? this.geometry,
        type: type ?? this.type,
        properties: properties ?? this.properties,
      );

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        type: json["type"],
        properties: json["properties"] == null
            ? null
            : Properties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
        "geometry": geometry?.toJson(),
        "type": type,
        "properties": properties?.toJson(),
      };
}

class Geometry {
  final List<double>? coordinates;
  final String? type;

  Geometry({
    this.coordinates,
    this.type,
  });

  Geometry copyWith({
    List<double>? coordinates,
    String? type,
  }) =>
      Geometry(
        coordinates: coordinates ?? this.coordinates,
        type: type ?? this.type,
      );

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
        "type": type,
      };
}

class Properties {
  final String? osmType;
  final int? osmId;
  final String? country;
  final String? osmKey;
  final String? city;
  final String? countrycode;
  final String? osmValue;
  final String? postcode;
  final String? name;
  final String? state;
  final String? type;

  Properties({
    this.osmType,
    this.osmId,
    this.country,
    this.osmKey,
    this.city,
    this.countrycode,
    this.osmValue,
    this.postcode,
    this.name,
    this.state,
    this.type,
  });

  Properties copyWith({
    String? osmType,
    int? osmId,
    String? country,
    String? osmKey,
    String? city,
    String? countrycode,
    String? osmValue,
    String? postcode,
    String? name,
    String? state,
    String? type,
  }) =>
      Properties(
        osmType: osmType ?? this.osmType,
        osmId: osmId ?? this.osmId,
        country: country ?? this.country,
        osmKey: osmKey ?? this.osmKey,
        city: city ?? this.city,
        countrycode: countrycode ?? this.countrycode,
        osmValue: osmValue ?? this.osmValue,
        postcode: postcode ?? this.postcode,
        name: name ?? this.name,
        state: state ?? this.state,
        type: type ?? this.type,
      );

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        country: json["country"],
        osmKey: json["osm_key"],
        city: json["city"],
        countrycode: json["countrycode"],
        osmValue: json["osm_value"],
        postcode: json["postcode"],
        name: json["name"],
        state: json["state"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "osm_type": osmType,
        "osm_id": osmId,
        "country": country,
        "osm_key": osmKey,
        "city": city,
        "countrycode": countrycode,
        "osm_value": osmValue,
        "postcode": postcode,
        "name": name,
        "state": state,
        "type": type,
      };
}
