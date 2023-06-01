import 'dart:io';
import 'package:dttassessment/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:dttassessment/pages/home.dart';
import 'package:dttassessment/models/house_model.dart';
import 'package:dttassessment/theme/colors.dart';

void main() {
  final House fakeItem = House(
    id: 1,
    price: 1,
    image: '',
    zip: '',
    bathrooms: 1,
    bedrooms: 1,
    size: 1,
    city: '',
    description: '',
    latitude: 1,
    longitude: 2,
    distance: 0,
  );

  runApp(Sizer(builder: (context, orientation, deviceType) {
    return MaterialApp(
      home: DetailsPage(
        selectedItem: fakeItem,
        distance: '',
      ),
    );
  }));

}


class DetailsPage extends StatefulWidget {
  final House selectedItem;
  final String distance;

  const DetailsPage({Key? key, required this.selectedItem, required this.distance})
      : super(key: key);

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  bool screenOpen = true;

  void launchMapsApp(double latitude, double longitude) async {
    String mapsUrl;
    if (Platform.isAndroid) {
      mapsUrl =
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    } else if (Platform.isIOS) {
      mapsUrl = 'http://maps.apple.com/?daddr=$latitude,$longitude';
    } else {
      throw 'Platform not supported.';
    }

    Uri uri = Uri.parse(mapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch maps app.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          screenOpen = false;
        });
      Navigator.of(context).pop();
      return false;
    },
    child:  Scaffold(
        body: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 25.h,
                      width: 100.w,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: Constants.baseAPIUrl + widget.selectedItem.image,
                            fit: BoxFit.cover,
                            width: 100.w,
                            height: 25.h,
                            placeholder: (context, url) =>
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                        ),
                        height: 100.h,
                        width: 100.w,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 5.w, right: 5.w, top: 5.h, bottom: 1.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(child: Text(
                                    // Regular Expression for put commas to the amount of money
                                    '\$${widget.selectedItem.price.toString()
                                        .replaceAllMapped(RegExp(
                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'), (
                                        Match m) => '${m[1]},')}',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'GothamSSm',
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.strong,
                                    ),
                                  )
                                  ),
                                  SizedBox(width: 8.4.w),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/Icons/ic_bed.svg',
                                          width: 2.h,
                                          height: 2.h,
                                          color: AppColors.medium,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          widget.selectedItem.bedrooms.toString(),
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.medium,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        SvgPicture.asset(
                                          'assets/Icons/ic_bath.svg',
                                          width: 2.h,
                                          height: 2.h,
                                          color: AppColors.medium,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          widget.selectedItem.bathrooms.toString(),
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.medium,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        SvgPicture.asset(
                                          'assets/Icons/ic_layers.svg',
                                          width: 2.h,
                                          height: 2.h,
                                          color: AppColors.medium,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          widget.selectedItem.size.toString(),
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.medium,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        SvgPicture.asset(
                                          'assets/Icons/ic_location.svg',
                                          width: 2.h,
                                          height: 2.h,
                                          color: AppColors.medium,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          '${widget.distance} km',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.medium,
                                          ),
                                        ),
                                      ]
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              const Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.strong,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                widget.selectedItem.description,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.medium,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              const Text(
                                "Location",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.strong,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              SizedBox(
                                height: 38.h,
                                child: Visibility(
                                  visible: screenOpen,
                                  child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        widget.selectedItem.latitude.toDouble(),
                                        widget.selectedItem.longitude.toDouble()),
                                    zoom: 12,
                                  ),
                                  markers: {
                                    Marker(
                                        markerId: const MarkerId(
                                            'targetMarker'),
                                        position: LatLng(
                                            widget.selectedItem.latitude.toDouble(),
                                            widget.selectedItem.longitude.toDouble()),
                                        infoWindow: const InfoWindow(
                                            title: 'House Location'),
                                        onTap: () {
                                          launchMapsApp(
                                              widget.selectedItem.latitude.toDouble(),
                                              widget.selectedItem.longitude
                                                  .toDouble());
                                        }
                                    ),
                                  },
                                ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 3.h,
                left: 2.w,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                ),
              ),
            ]
        )
    )
    );
  }

  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
