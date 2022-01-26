import 'dart:io';

import 'package:christ_university/utils/resuable_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageUploader extends StatefulWidget {

  final clubName;
  const ImageUploader({Key? key, required this.clubName}) : super(key: key);

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {

  File? file;
  UploadTask? task;


  Future imagePicker() async {
    final filePicker = await FilePicker.platform.pickFiles(
        allowMultiple: false);

    if (filePicker == null) return;
    final pathOfTheFile = filePicker.files.single.path!;

    setState(() {
      file = File(pathOfTheFile);
    });
  }

  Future imageUploader() async{
    if (file == null) return;

    final destination = 'clubLogos/${widget.clubName}';
    task = FirebaseApi.uploadTask(destination, file!);

    if (task == null) return;

    final snapShot = await task!.whenComplete(() {
      print("uploaded");
    });
    final url = snapShot.ref.getDownloadURL();

    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('Upload Image for ${widget.clubName}')
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            (file == null)? Text("Please Select a File") : Image.file(file!, height: 200, width: 200,),
            SizedBox(height: 20,),
            Material(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                onTap: () => imagePicker(),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Choose File",
                        style:
                        TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text("File Name : ${widget.clubName}.jpg, \n\nClick on upload button to upload the Image.",
              textAlign: TextAlign.center,
              style: TextStyle(
              ),
            ),
            SizedBox(height: 20,),
            Material(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                onTap: () => imageUploader(),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Upload File",
                        style:
                        TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
