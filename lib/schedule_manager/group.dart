import "package:json_annotation/json_annotation.dart";

part "group.g.dart";

@JsonSerializable()
class Group {
  final String name;
  final String year;
  final String calendarUrl;

  Group({required this.name, required this.year, required this.calendarUrl});

  @override
  String toString() {
    return "Group: ${name}\nYear: ${year}\nURL: ${calendarUrl}\n";
  }

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
