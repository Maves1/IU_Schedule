import "dart:collection";
import "dart:convert";
import "package:json_annotation/json_annotation.dart";

part "notifications.g.dart";

@JsonSerializable(explicitToJson: true)
class Notifications {

  final int currentId;
  // Below positions in the map stand for following: <Event, Notify>>
  final Map<String, bool> map;

  Map<String, bool> get getMap => map;

  Notifications({required this.currentId, required this.map});

  factory Notifications.fromJson(Map<String, dynamic> json) => _$NotificationsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsToJson(this);

  // Notifications.fromJson(Map<String, dynamic> json) {
  //   map = jsonDecode(json['map']);
  // }
  //
  // Map<String, dynamic> toJson() => {
  //   'map' : jsonEncode(map),
  // };
}