import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlp_administration/model/description_model.dart';
import 'package:mlp_administration/model/image_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController statementController = TextEditingController();
  TextEditingController docIdController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String downloadlinkk = "";
  bool spinner = false;
  uploadPic() async {
    File? file;
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      spinner = true;
      file = File(image.path);
    });
    final reference = storage.ref().child("images/files");

    final uploadTask = reference.putFile(file!);
    await uploadTask.whenComplete(() => {});
    final downloadlink = await reference.getDownloadURL();
    log("Download link is ${downloadlink}");
    // return downloadlink;
    setState(() {
      downloadlinkk = downloadlink.toString();
      spinner = false;
    });
  }

  uploadImageContent() {
    if (downloadlinkk != "") {
      ImageModel _imageModel = ImageModel(
          docid: "docid",
          userid: "userid",
          imageurl: downloadlinkk.toString(),
          variable: "variable",
          slug: "slug",
          description: "description");
      firebaseFirestore
          .collection("imageContent")
          .doc()
          .set(_imageModel.toMap());
      log("Data uploaded");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("file Uploaded"),
        backgroundColor: Colors.green,
      ));
      setState(() {
        downloadlinkk = "";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("pehle file upload kr!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  uploadText() {
    if (docIdController.text != "") {
      DescriptionModel _descriptionModel = DescriptionModel(
          textid: "textid",
          userid: "userid",
          imageurl: "imageurl",
          variable: "variable",
          description: statementController.text.trim());
      firebaseFirestore
          .collection("Descriptions")
          .doc(docIdController.text.trim())
          .set(_descriptionModel.toMap());
      log("Data uploaded");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Description Uploaded"),
        backgroundColor: Colors.green,
      ));
      setState(() {
        docIdController.clear();
        statementController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("pehle file kuch likh fir kr!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Data")),
      body: SafeArea(
        child: Center(
          child: ModalProgressHUD(
            inAsyncCall: spinner,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Select Image to Upload!!"),
                  CupertinoButton(
                      child: Text("Press to upload image"),
                      onPressed: () {
                        uploadPic();
                      }),
                  CupertinoButton(
                    child: Text(
                      "Final upload",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      uploadImageContent();
                    },
                    color: Colors.orangeAccent,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: docIdController,
                    decoration:
                        InputDecoration(label: Text("Enter the Document Id")),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: statementController,
                    decoration:
                        InputDecoration(label: Text("Enter the description")),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    child: Text("Upload Data"),
                    onPressed: () {
                      uploadText();
                    },
                    color: Colors.deepOrangeAccent,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
