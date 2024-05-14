class FlightModel {

  String? flightNumber; // Added this attribute
  String? start;
  String? destination;
  String? departureTime;
  String? arrivalTime;
  String? travelDuration;
  String? id;

  FlightModel({
    this.flightNumber,
    this.start,
    this.destination,
    this.departureTime,
    this.arrivalTime,
    this.travelDuration,
    this.id,

  });

  FlightModel.fromJson(Map<String, dynamic> json) {

    flightNumber = json['flightNumber']; // Added for deserialization
    start = json['start'];
    destination = json['destination'];
    departureTime = json['departureTime'];
    arrivalTime = json['arrivalTime'];
    travelDuration = json['travelDuration'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['flightNumber'] = flightNumber; // Added for serialization


    return data;
  }
}
