import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Utils/api_endpoints.dart';
import '../models/flight_model.dart';

class FlightClient {
  FlightClient() {}

  Future<bool> createFlight(FlightModel flightModel) async {
    var url = Uri.parse(Api_Endpoints.FLIGHT);
    try {
      var response = await http.post(
        url,
        body: flightModel.toJson(),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<bool> updateFlight(FlightModel flightModel, String id) async {
    var url = Uri.parse("${Api_Endpoints.FLIGHT}?id=$id");
    try {
      var response = await http.put(
        url,
        body: flightModel.toJson(),
      );

      print("-----============================= 2");
      print(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<List<FlightModel>> getFlight(int skip) async {
    var url = Uri.parse(Api_Endpoints.FLIGHT + "?skip=$skip");
    try {
      var response = await http.get(url);
      var listOfFlight = jsonDecode(response.body) as List;
      if (response.statusCode == 200) {
        return listOfFlight
            .map((element) => FlightModel.fromJson(element))
            .toList();
      } else {
        throw Exception("Fail To load");
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<bool> deleteFlight(String id) async {
    var url = Uri.parse("${Api_Endpoints.FLIGHT}?id=$id");
    try {
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw false;
      }
    } catch (err) {
      throw Exception(err);
    }
  }
}
