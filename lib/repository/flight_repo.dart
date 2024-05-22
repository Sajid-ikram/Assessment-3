import '../client/flight_client.dart';
import '../models/flight_model.dart';

class FlightRepo {
  static final FlightRepo _instance = FlightRepo();
  FlightClient? _flightClient;

  FlightClient getFlightClient() {
    _flightClient ??= FlightClient();
    return _flightClient!;
  }

  void initializeClient() {
    _flightClient = FlightClient();
  }

  static FlightRepo get instance => _instance;

  Future<bool> createFlight(
      Map<String, dynamic> flightData) async {
    int retry = 0;
    FlightModel flightModel = FlightModel.fromJson(flightData);


    bool response = false;

    while (retry++ < 2) {
      try {
        response = await FlightRepo.instance
            .getFlightClient()
            .createFlight(flightModel);

        return response;
      } catch (err) {
        throw Exception("Something went wrong");
      }
    }
    return response;
  }

/*  Future<bool> updateFlight(
      String name, String description, String imageUrl, String id) async {

    int retry = 0;
    FlightModel flightModel =
    FlightModel(name: name, description: description, imageUrl: imageUrl);

    bool response = false;

    while (retry++ < 2) {
      try {
        response = await FlightRepo.instance
            .getFlightClient()
            .updateFlight(flightModel, id);

        return response;
      } catch (err) {
        throw Exception("Something went wrong");
      }
    }
    return response;
  }*/

  Future<List<FlightModel>> getFlight(int skip) async {
    try {
      List<FlightModel> response =
          await FlightRepo.instance.getFlightClient().getFlight(skip);

      return response;
    } catch (err) {
      print("Something went wrong ------------------------------------------- 1 11");
      print(err);
      print("Something went wrong -------------------------------------------");
      throw Exception("Something went wrong");
    }
  }

  Future<bool> deleteFlight(String id) async {
    try {
      bool response =
      await FlightRepo.instance.getFlightClient().deleteFlight(id);

      return response;
    } catch (err) {
      throw Exception("Something went wrong");
    }
  }
}
