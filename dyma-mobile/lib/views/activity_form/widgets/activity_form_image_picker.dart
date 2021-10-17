import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ActivityFormImagePicker extends StatefulWidget {
  const ActivityFormImagePicker({Key? key}) : super(key: key);

  @override
  _ActivityFormImagePickerState createState() =>
      _ActivityFormImagePickerState();
}

class _ActivityFormImagePickerState extends State<ActivityFormImagePicker> {
  File? _deviceImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        print("image ok");
        print(pickedFile);
        // pour créer un fichier de ce picked file, on File son path simplement
        _deviceImage = File(pickedFile.path);
        print("device image: $_deviceImage");
        setState(() {
          print("rebuild to show image picked");
        });
      } else {
        print("no image");
        print(pickedFile);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  print("gallery");
                  _pickImage(ImageSource.gallery);
                },
                icon: Icon(Icons.photo),
                label: Text("Galery"),
              ),
              TextButton.icon(
                onPressed: () {
                  print("camera");
                  _pickImage(ImageSource.camera);
                },
                icon: Icon(Icons.photo_camera),
                label: Text("Camera"),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            child: _deviceImage != null
                ? Image.file(_deviceImage!)
                : Text("Aucune Image"),
          )
        ],
      ),
    );
  }
}
