// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, unused_import

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class ProfileDetails extends StatefulWidget {
  UserDetails? userdetailsss;

  ProfileDetails({required this.userdetailsss});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _saveImage(_image!);
    }
  }

  Future<void> _saveImage(File image) async {
    final prefs = await SharedPreferences.getInstance();
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);
    prefs.setString('profileImage', base64Image);
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('profileImage');
    if (base64Image != null) {
      final bytes = base64Decode(base64Image);
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/profileImage.png';
      final file = await File(filePath).writeAsBytes(bytes);
      setState(() {
        _image = file;
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Details',
          style: TextStyle(color: ColorConstant.whiteA700),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.whiteA700,
          ),
        ),
        backgroundColor: ColorConstant.ismcolor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Image:'),
            // Container(
            // height: 300,
            // width: 300,
            // decoration: BoxDecoration(border: Border.all()),
            // child: Image.memory(details!.imageByteArray!)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 120,
                            backgroundImage: FileImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 120,
                            backgroundImage:
                                AssetImage('assets/images/image1.jpg'),
                          ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _showPicker(context),
                      child: Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 40.0),
            Text(
              'User ID: ${widget.userdetailsss!.id}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10.0),
            Text(
              'First Name: ${widget.userdetailsss!.firstName ?? ""}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10.0),
            Text(
              'Last Name: ${widget.userdetailsss!.lastName ?? ""}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10.0),
            Text(
              'D.O.B: ${widget.userdetailsss!.dob ?? ""}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: ${widget.userdetailsss!.email ?? ""}',
              style: TextStyle(fontSize: 18),
            ),

            /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      image != null
                          ? Image.memory(
                              imagebytearray!,
                              width: 100,
                              height: 100,
                            )
                          : Text('No image selected'),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              getImage(ImageSource.gallery);
                              // pickImage(ImageSource.gallery);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.lightBlue701,
                              elevation: 3,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Gallery',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 05,
                                ),
                                Icon(
                                  Icons.image,
                                  color: ColorConstant.whiteA700,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getImage(ImageSource.camera);
                              // pickImage(ImageSource.camera);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.lightBlue701,
                              elevation: 3,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Camara',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 05,
                                ),
                                Icon(
                                  Icons.camera_enhance,
                                  color: ColorConstant.whiteA700,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
