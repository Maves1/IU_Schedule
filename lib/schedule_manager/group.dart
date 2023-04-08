class Group {
  final String name;
  final String year;
  final String calendarUrl;

  Group(this.name, this.year, this.calendarUrl);

  @override
  String toString() {
    return "Group: ${name}\nYear: ${year}\nURL: ${calendarUrl}\n";
  }
}