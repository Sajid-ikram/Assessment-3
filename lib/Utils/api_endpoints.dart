
import 'package:flutter/foundation.dart';

class Api_Endpoints {
  //static const baseUrl = "https://lu-bus-tracker-backend.vercel.app/";
  static const baseUrl = kIsWeb ? "http://localhost:8000/" : "http://10.0.2.2:8000/";



  //Notice SERVICE ENDPOINTS

  static const String FLIGHT = "${baseUrl}flight";






}
