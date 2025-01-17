// ignore_for_file: unnecessary_new, curly_braces_in_flow_control_structures, unnecessary_this
class LocationClass {
  String? Longitude;
  String? Latitude;
  String? address;

  LocationClass({this.address, this.Latitude, this.Longitude});

  LocationClass.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    Latitude = json['Latitude'];
    Longitude = json['Longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['Latitude'] = this.Latitude;
    data['Longitude'] = this.Longitude;
    return data;
  }
}
