import 'dart:math';
import 'dart:convert';
import 'package:dttassessment/utils/constants.dart';
import 'package:dttassessment/widgets/about.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'package:dttassessment/theme/colors.dart';
import 'package:dttassessment/list/listview_widget.dart';
import 'package:dttassessment/models/house_model.dart';


void main(){
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil.setScreenSize(constraints, orientation);
            return MaterialApp(
              title: 'Bottom Navigation Demo',
              theme: ThemeData(
                fontFamily: 'GothamSSm',
              ),
              home: const MyHomePage(),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  List<House> houses = [];
  String searchText = '';
  final TextEditingController searchController = TextEditingController();
  Position? currentLocation;

  List<String> appBarTitles = ['DTT REAL ESTATE','ABOUT'];

  Future<void> askLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.denied) {
      // Location permission is denied, request it from the user
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      } else{
        setState(() {
            fetchHouses();
        });
      }
    }
  }

  Future<void> fetchHouses() async {
    final headers = {'Access-Key': Constants.apiKEY};

    final response = await http.get(Uri.parse(Constants.houseAPIUrl), headers: headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<House> houseList = [];

      for (var houseData in jsonData) {
        int latitude = houseData['latitude'];
        int longitude = houseData['longitude'];
        double distance = await calculateDistance(latitude.toDouble(),longitude.toDouble());
        print(double.parse(distance.toStringAsFixed(1)));
        final house = House(
          id: houseData['id'],
          price: houseData['price'],
          image: houseData['image'],
          zip: houseData['zip'],
          bathrooms: houseData['bathrooms'],
          bedrooms: houseData['bedrooms'],
          size: houseData['size'],
          city: houseData['city'],
          description: houseData['description'],
          latitude: houseData['latitude'],
          longitude: houseData['longitude'],
          distance: double.parse(distance.toStringAsFixed(1)),
        );
        houseList.add(house);
      }
      setState(() {
        houseList.sort((a, b) => a.price.compareTo(b.price));// Sorting from the cheapest to most expensive one
        houses = houseList;
      });
    } else {
      throw Exception('Failed to fetch houses');
    }
  }

  Future<double> calculateDistance(double houseLatitude, double houseLongitude) async {

    if (currentLocation == null) {
      // Get current location if location permission allowed
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }
    }
    if (currentLocation == null) return 0; //current location not found

    double lat1 = currentLocation!.latitude;
    double lon1 = currentLocation!.longitude;
    double lat2 = houseLatitude;
    double lon2 = houseLongitude;

    const double earthRadius = 6371; // Radius of the earth in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c; // Distance in km

    return distance;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void clearSearch() {
    setState(() {
      searchText = '';
      searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    askLocationPermission();
    fetchHouses();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.75.h, bottom: 1.5.h, right: 4.2.w, left: 4.2.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 4.w, top: 0.4.h),
                child: TextField(
                  controller: searchController,
                  cursorColor: AppColors.medium,
                  style: const TextStyle(
                    color: AppColors.strong,
                    fontFamily: 'GothamSSm',
                    fontWeight: FontWeight.w300,
                    fontSize: 17,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for a home',
                    hintStyle: const TextStyle(
                      color: AppColors.medium,
                      fontFamily: 'GothamSSm',
                    ),
                    suffixIcon: searchText.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.strong),
                      onPressed: () {
                        setState(() {
                          clearSearch();
                        });
                      },
                    )
                        : IconButton(
                      icon: const Icon(Icons.search, color: AppColors.medium),
                      onPressed: () {
                      },
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListViewWidget(houseList: houses, searchText: searchText,),
          ),
        ],
      ),
      const AboutWidget(),
    ];

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        bottomOpacity: 0.0,
        elevation: 0.0,
        flexibleSpace: Container(
          margin: EdgeInsets.only(left: 4.5.w, top: 5.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              appBarTitles[selectedIndex],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: 'GothamSSm',
                color: AppColors.strong,
              ),
            ),
          ),
        ),
      ),
      body: SizerUtil.orientation == Orientation.portrait
          ? widgetOptions.elementAt(selectedIndex)
          : Row(
        children: [
          Expanded(
            flex: 1,
            child: widgetOptions.elementAt(selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
        currentIndex: selectedIndex,

        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.strong,
        unselectedItemColor: AppColors.light,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: onItemTapped,
      ),
    );
  }
}