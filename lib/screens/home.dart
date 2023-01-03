import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futminna_project_1/controllers/auth.dart';
import 'package:futminna_project_1/controllers/share.dart';
import 'package:futminna_project_1/extension/screen.dart';
import 'package:futminna_project_1/models/property.dart';
import 'package:futminna_project_1/utils/common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // late GoogleMapController mapController;
  // late BitmapDescriptor customIcon;

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  MapController? controller;

  bool mapPermission = false;

  PropertyModel? property;

  @override
  void initState() {
    super.initState();
    _requestMapPermission().then((value) {
      if (value) {
        _currentLocation().then((value) {
          controller = MapController(
            initMapWithUserPosition: false,
            initPosition:
                GeoPoint(latitude: value.latitude, longitude: value.longitude),
            areaLimit: BoundingBox(
              east: 10.4922941,
              north: 47.8084648,
              south: 45.817995,
              west: 5.9559113,
            ),
          );
          setState(() {});
          controller!
              .addMarker(
                  GeoPoint(
                      latitude: value.latitude, longitude: value.longitude),
                  markerIcon: MarkerIcon(
                    icon: const Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                    iconWidget: const Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  angle: pi / 3)
              .then((_) {
            setState(() {});
          });
        });
      }
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void onClickMarker(PropertyModel data) {
    setState(() {
      property = data;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<Position> _currentLocation() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<bool> _requestMapPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          mapPermission = false;
        });
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        mapPermission = false;
      });
      return false;
    }

    return true;
  }

  SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle.light
      .copyWith(systemNavigationBarColor: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final auth = ref.watch(authControllerProvider);
      final share = ref.watch(shareController);
      return Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: SizedBox(
              width: context.screenWidth(0.8),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFEFEFEF),
                        radius: 150,
                        child: Icon(
                          Icons.person,
                          size: 200,
                          color: Color(0xFF656565),
                        ),
                      ),
                      Text(auth.user!.fullName!,
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontWeight: FontWeight.w900)),
                      Text(auth.user!.email!,
                          style: Theme.of(context).textTheme.bodyText2!),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {},
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: context.screenWidth(1),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: const Color(0xFFCCCCCC),
                                  width: 1,
                                  style: BorderStyle.solid)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Datas',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 14),
                              ),
                              const Icon(Icons.place,
                                  color: Commons.primaryColor)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {},
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: context.screenWidth(1),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: const Color(0xFFCCCCCC),
                                  width: 1,
                                  style: BorderStyle.solid)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add Data',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 14),
                              ),
                              const Icon(Icons.place,
                                  color: Commons.primaryColor)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await auth.signOut();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: context.screenWidth(1),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: const Color(0xFFCCCCCC),
                                  width: 1,
                                  style: BorderStyle.solid)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Logout',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 14),
                              ),
                              const Icon(Icons.logout,
                                  color: Commons.primaryColor)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: share.getMapPermission()! || mapPermission
            ? Stack(
                children: [
                  FutureBuilder<Position>(
                      future: _currentLocation(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                              "Failed to get user location.",
                              style: Theme.of(context).textTheme.bodyText1,
                            ));
                          } else {
                            // Position? snapshotData = snapshot.data;

                            // setState(() {
                            //   controller = MapController(
                            //     initMapWithUserPosition: false,
                            //     initPosition: GeoPoint(
                            //         latitude: snapshotData!.latitude,
                            //         longitude: snapshotData.longitude),
                            //     areaLimit: BoundingBox(
                            //       east: 10.4922941,
                            //       north: 47.8084648,
                            //       south: 45.817995,
                            //       west: 5.9559113,
                            //     ),
                            //   );
                            // });
                            return OSMFlutter(
                              controller: controller!,
                              trackMyPosition: false,
                              initZoom: 12,
                              minZoomLevel: 8,
                              maxZoomLevel: 18,
                              stepZoom: 1.0,
                              userLocationMarker: UserLocationMaker(
                                personMarker: const MarkerIcon(
                                  icon: Icon(
                                    Icons.location_history_rounded,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                ),
                                directionArrowMarker: const MarkerIcon(
                                  icon: Icon(
                                    Icons.double_arrow,
                                    size: 48,
                                  ),
                                ),
                              ),
                              roadConfiguration: RoadConfiguration(
                                startIcon: const MarkerIcon(
                                  icon: Icon(
                                    Icons.person,
                                    size: 64,
                                    color: Colors.brown,
                                  ),
                                ),
                                roadColor: Colors.yellowAccent,
                              ),
                              markerOption: MarkerOption(
                                  defaultMarker: const MarkerIcon(
                                icon: Icon(
                                  Icons.person_pin_circle,
                                  color: Colors.blue,
                                  size: 56,
                                ),
                              )),
                            );
                          }
                        }
                        return const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Commons.primaryColor)),
                          ),
                        );
                      }),
                  SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: InkWell(
                            onTap: () => scaffoldKey.currentState?.openDrawer(),
                            child: const CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.menu),
                            ),
                          ),
                        ),
                        if (property != null)
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: context.screenWidth(1),
                                height: 220,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFFFFFF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                              0xFF000000)
                                                          .withOpacity(0.05),
                                                      spreadRadius: 0,
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(0, 0),
                                                    ),
                                                  ]),
                                              width: 74,
                                              height: 74,
                                              child: property!
                                                      .featuredImage!.isNotEmpty
                                                  ? Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: CachedNetworkImageProvider(
                                                                  property!
                                                                      .featuredImage!))),
                                                    )
                                                  : const Icon(
                                                      Icons.location_on,
                                                      size: 100,
                                                      color: Color(0xFF656565),
                                                    )),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                property!.name!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                property!.location!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '${calculateDistance(double.parse(property!.latitude!), double.parse(property!.longitude!), double.parse(property!.latitude!), double.parse(property!.longitude!))}km Away',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: Commons
                                                            .primaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // MaterialButton(
                                    //   onPressed: () => showCupertinoModalBottomSheet(
                                    //     elevation: 0,
                                    //     expand: true,
                                    //     shadow: const BoxShadow(
                                    //         color: Colors.transparent),
                                    //     backgroundColor: Colors.transparent,
                                    //     transitionBackgroundColor: Colors.transparent,
                                    //     context: context,
                                    //     builder: (context) => BookModal(
                                    //       item: property!,
                                    //       km: calculateDistance(
                                    //           double.parse(property!.latitude!),
                                    //           double.parse(property!.longitude!),
                                    //           double.parse(property!.latitude!),
                                    //           double.parse(property!.longitude!)),
                                    //     ),
                                    //   ),
                                    //   elevation: 0,
                                    //   color: Commons.primaryColor,
                                    //   shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(10),
                                    //   ),
                                    //   child: Container(
                                    //     width: context.screenWidth(1),
                                    //     height: 53,
                                    //     alignment: Alignment.center,
                                    //     child: Text(
                                    //       'Book this Truck',
                                    //       style: Theme.of(context)
                                    //           .textTheme
                                    //           .bodyText1!
                                    //           .copyWith(color: Commons.whiteColor),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ))
                      ],
                    ),
                  )
                ],
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.map,
                                size: 150,
                                color: Color(0xFFCCCCCC),
                              ),
                              Text(
                                'Allow the app to locate your location\nto find the trucks near you',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                final result = await _requestMapPermission();
                                await share.updateMapPermission(result);
                              },
                              elevation: 0,
                              color: Commons.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: context.screenWidth(1),
                                height: 53,
                                alignment: Alignment.center,
                                child: Text(
                                  'Allow',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Commons.whiteColor),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ]),
                ),
              ),
      );
    });
  }
}
