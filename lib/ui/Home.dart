import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:batik_detector/constant/ScreenSize.dart';
import 'package:batik_detector/constant/color.dart';
import 'package:batik_detector/ui/component/Info.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  File imageFile;

  String result;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  dispose() {
    super.dispose();
    Tflite.close();
  }

/// Load model 
  Future loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

/// get image from phone
  void getImage(ImageSource imageSource) async {
    var image = await ImagePicker().getImage(source: imageSource);
    if (image == null) {
      return null;
    } else {
      setState(() {
        isLoading = true;
        imageFile = File(image.path);
      });
      detectingImage(imageFile);
    }
  }


/// processing image dan get result
  void detectingImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    await Future.delayed(Duration(seconds: 3));
    setState(() {
      if (output.length > 0 &&
          double.parse(output[0]['confidence'].toString()) > 0.98) {
        result = output[0]['label'].toString().replaceAll(RegExp(r'[0-9]'), '');
      } else {
        result = null;
      }

      isLoading = false;

      print(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Batik Detector",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              /// show Info BottomSheet
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  context: (context),
                  builder: (context) {
                    return buildInfo(context);
                  });
            },
            color: Colors.white,
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      /// if image is processing/detecting then show onDetecting widget method, else show main widget
      body: isLoading ? onDetecting(context) : mainMenu(context),
    );
  }


/// main widget for inital widget
  Container mainMenu(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getHeight(context) * 0.02),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          /// if image null then show illustration else show image
          imageFile == null
              ? Padding(
                  padding: EdgeInsets.all(getHeight(context) * 0.038),
                  child: Container(
                    height: getHeight(context) * 0.38,
                    width: getHeight(context) * 0.38,
                    child: SvgPicture.asset(
                      "assets/Search-rafiki.svg",
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: getHeight(context) * 0.038),
                  child: Container(
                    height: getHeight(context) * 0.3,
                    width: getHeight(context) * 0.45,
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 3),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: FileImage(imageFile), fit: BoxFit.cover),
                        color: primaryColor),
                  ),
                ),
                
          SizedBox(
            height: 10,
          ),

          /// if image null and result null then show container and Result
          imageFile == null
              ? Container()
              : (result == null)
                  ? Text(
                      "Motif Batik tidak diketahui",
                      style: TextStyle(
                          fontSize: getHeight(context) * 0.030,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    )
                  : Text(
                      result,
                      style: TextStyle(
                          fontSize: getHeight(context) * 0.030,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),


          imageFile == null? SizedBox(
            height: 0,
          ) : SizedBox(
            height: getHeight(context) * 0.07,
          ),

          /// Button for pick image
          Container(
            height: getHeight(context) * 0.067,
            width: getHeight(context) * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 7,
                    color: primaryColor.withOpacity(0.5),
                    offset: Offset(0, 2),
                  ),
                ]),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {

                  ///show modal pickerImage
                  showModalBottomSheet(
                      context: (context),
                      shape: StadiumBorder(),
                      builder: (context) => buildPickerImage());

                },
                borderRadius: BorderRadius.circular(20),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    Text("Cari Tahu",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ],
                )),
              ),
            ),
          )
        ],
      ),
    );
  }


/// widget show while image processing
  Container onDetecting(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getHeight(context) * 0.02),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(
              getHeight(context) * 0.034,
            ),
            child: Container(
              height: getHeight(context) * 0.35,
              width: getHeight(context) * 0.35,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        primaryColor,
                        primaryColor.withOpacity(0.9),
                      ])),
              child: Center(
                  child: Shimmer.fromColors(
                      baseColor: primaryColor.withOpacity(0.1),
                      highlightColor: Colors.white.withOpacity(0.9),
                      child: Text(
                        "MEMPROSES",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getHeight(context) * 0.045),
                      ))),
            ),
          ),
        ],
      ),
    );
  }


/// Widget modal pick image, pick image from camera or gallery
  Container buildPickerImage() {
    return Container(
      height: getHeight(context) * 0.2,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "btnCamera",
                backgroundColor: primaryColor,
                onPressed: () {
                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: Icon(Icons.camera),
              ),
              Text("Kamera")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "btnGallery",
                backgroundColor: primaryColor,
                onPressed: () {
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: Icon(Icons.photo_album),
              ),
              Text("Gallery")
            ],
          ),
        ],
      ),
    );
  }
}
