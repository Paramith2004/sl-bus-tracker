class BusRoute {
  final String id;
  final String routeNumber;
  final String from;
  final String to;
  final String distance;
  final String duration;
  final List<String> stops;
  final List<BusSchedule> schedules;
  final String type;

  BusRoute({
    required this.id,
    required this.routeNumber,
    required this.from,
    required this.to,
    required this.distance,
    required this.duration,
    required this.stops,
    required this.schedules,
    required this.type,
  });
}

class BusSchedule {
  final String departure;
  final String arrival;
  final String busType;

  BusSchedule({
    required this.departure,
    required this.arrival,
    required this.busType,
  });
}