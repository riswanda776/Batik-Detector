import 'package:flutter/material.dart';
import 'package:batik_detector/constant/ScreenSize.dart';
import 'package:url_launcher/url_launcher.dart';


/// widget information about this app
Container buildInfo(BuildContext context) {
  String url = "https://www.kaggle.com/dionisiusdh/indonesian-batik-motifs";
    return Container(
      height: getHeight(context) * 0.43,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Padding(
        padding: EdgeInsets.all(getHeight(context) * 0.033,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Batik Detector",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: getHeight(context) * 0.032),
            ),
            Text(
                "Adalah sebuah Aplikasi untuk mendeteksi Jenis atau Motif Batik. \ndibuat menggunakan Flutter dan Tensorflow untuk Training Model"),
            SizedBox(
              height: 10,
            ),
            Text(
              "Dataset :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: getHeight(context) * 0.029,),
            ),
            InkWell(
              onTap: () async {
                
                if (await canLaunch(url)) {
                  launch(url);
                }
              },
              child: Text(
                  url),
            )
          ],
        ),
      ),
    );
  }