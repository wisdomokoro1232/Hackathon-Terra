class DataQuerier {
  String baseUrl = "https://night-guard-backend.herokuapp.com/";

  static WearableInfo getInfo(bool drinkingAlcohol, bool takingDrugs) {
    
    return WearableInfo(12, 10.0, 10.0, false);
  }
}

class WearableInfo {
  final int heartRate;
  final double bloodPressure;
  final double bodyTemp;
  final bool spiked;

  WearableInfo(this.heartRate, this.bloodPressure, this.bodyTemp, this.spiked);
}