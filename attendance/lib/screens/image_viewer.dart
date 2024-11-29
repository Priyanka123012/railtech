// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ImageViewerScreen extends StatelessWidget {
  final String image;
  final String location;
  final String dateTime;
  const ImageViewerScreen({
    Key? key,
    required this.image,
    required this.location,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("$location");
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            'Image view',
            maxLines: 1,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green.shade900,
          elevation: 0,
        ).gradientBackground(withActions: true),
        body: Stack(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                width: MediaQuery.of(context).size.width * 0.98,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 10,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_sharp,
                        color: Colors.white,
                      ),
                      10.widthBox,
                      Text(
                        '$dateTime',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 10,
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                      10.widthBox,
                      Text(
                        "$location",
                        style: TextStyle(color: Colors.white),
                      ).expand(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
