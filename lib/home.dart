import 'dart:math';
import 'dart:convert';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dttassessment/theme/colors.dart';
import 'package:dttassessment/list/listview_widget.dart';
import 'package:dttassessment/list/house_item_structure.dart';




void main(){
  runApp(const HomeScreen());
}
const appColors = AppColors();
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
              home: MyHomePage(),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<House> houses = [];
  String _searchText = '';
  TextEditingController _searchController = TextEditingController();
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
    final url = 'https://intern.d-tt.nl/api/house';
    final headers = {'Access-Key': '98bww4ezuzfePCYFxJEWyszbUXc7dxRx'};

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<House> houseList = [];

      for (var houseData in jsonData) {
        int latitude = houseData['latitude'];
        int longitude = houseData['longitude'];
        double distance = await calculateDistance(latitude.toDouble(),longitude.toDouble());
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
          distance: distance.toInt(),
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
    _searchController.dispose();
    super.dispose();
  }

  void clearSearch() {
    setState(() {
      _searchText = '';
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    askLocationPermission();
    fetchHouses();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = [
      Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.75.h, bottom: 1.5.h, right: 4.2.w, left: 4.2.w),
            child: Container(
              decoration: BoxDecoration(
                color: appColors.darkGray,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 4.w, top: 0.4.h),
                child: TextField(
                  controller: _searchController,
                  cursorColor: appColors.medium,
                  style: TextStyle(
                    color: appColors.strong,
                    fontFamily: 'GothamSSm',
                    fontWeight: FontWeight.w300,
                    fontSize: 17,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for a home',
                    hintStyle: TextStyle(
                      color: appColors.medium,
                      fontFamily: 'GothamSSm',
                    ),
                    suffixIcon: _searchText.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear, color: appColors.strong),
                      onPressed: () {
                        setState(() {
                          clearSearch();
                        });
                      },
                    )
                        : IconButton(
                      icon: Icon(Icons.search, color: appColors.medium),
                      onPressed: () {
                      },
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListViewWidget(houseList: houses, searchText: _searchText,),
          ),
        ],
      ),
      Column(
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0.5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Greetings I am Sabahattin, a mobile app developer with four years of extensive experience in the field. I am also the person who developed DTT Real Estate app. Discover a new way to navigate the market with DTT Real Estate. '
                          'Effortlessly browse properties, access comprehensive info, and schedule viewings with ease. Stay ahead with regular updates driven by DTT\'s passion for innovation.'
                          ' Embrace the future of real estate today. With DTT Real Estate, you can effortlessly explore a vast range of properties, browse through stunning images, and access comprehensive information.'
                          ' Experience the ease of browsing stunning visuals, exploring detailed descriptions, and accessing crucial information such as pricing, location, and amenities. '
                          'DTT Real Estate goes beyond just listing properties. It embraces the essence of the Netherlands, highlighting the vibrant neighborhoods, cultural landmarks, and unique lifestyle offerings that make each location special. ',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                        color: appColors.medium,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Design and Development",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: appColors.strong,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Image.asset('assets/Images/dtt_banner.png'),
                        SizedBox(width: 6.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "by DTT",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                                color: appColors.strong,
                              ),
                            ),
                            SizedBox(height: 0.3.h),
                            Center(
                              child: InkWell(
                                  child: Text(
                                    "d-tt.nl",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  onTap: () => launch('https://d-tt.nl')
                              ),
                            )
                          ],
                        ),
                      ]
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      )
    ];

    return Scaffold(
      backgroundColor: appColors.lightGray,
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
              appBarTitles[_selectedIndex],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: 'GothamSSm',
                color: appColors.strong,
              ),
            ),
          ),
        ),
      ),
      body: SizerUtil.orientation == Orientation.portrait
          ? _widgetOptions.elementAt(_selectedIndex)
          : Row(
        children: [
          Expanded(
            flex: 1,
            child: _widgetOptions.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,

        backgroundColor: appColors.white,
        selectedItemColor: appColors.strong,
        unselectedItemColor: appColors.light,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: _onItemTapped,
      ),
    );
  }
}