// ignore_for_file: unnecessary_new, curly_braces_in_flow_control_structures, unnecessary_this

//import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class Profile {
  String? proId;
  String? proname;
  String? proemail;
  String? promobileno;
  String? propassword;
  XFile? image;
  //Uint8List? imageByteArray;
  String? issaved;
  String? role;

  Profile(
      {this.proId,
      this.proname,
      this.proemail,
      this.promobileno,
      //this.imageByteArray,
      this.propassword,
      this.image,
      this.issaved,
      this.role});

  Profile.fromJson(Map<String, dynamic> json) {
    proId = json['proId'];
    proname = json['proname'];
    proemail = json['proemail'];
    promobileno = json['promobileno'];
    propassword = json['propassword'];
    role = json['role'];
    //if (json['imageByteArray'] != null)
    // imageByteArray = base64.decode(json['imageByteArray']);
    issaved = json['issaved'];
    image = json['image'];
    // if (inputType == 'image') {
    //   if (value!.length != 0)
    //     image = XFile.fromData(base64.decode(value!));
    //   else
    //     image = XFile(
    //         "imageupload.png"); //yeh code check kar lena i dont know ki static image kese feed karte XFile me
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['proId'] = this.proId;
    data['proname'] = this.proname;
    data['proemail'] = this.proemail;
    data['promobileno'] = this.promobileno;
    data['propassword'] = this.propassword;
    //data['imageByteArray'] = this.imageByteArray;
    data['issaved'] = this.issaved;
    data['role'] = this.role;
    data['image'] = this.image;
    return data;
  }
}
