import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:futminna_project_1/controllers/auth.dart';
import 'package:futminna_project_1/controllers/property.dart';
import 'package:futminna_project_1/controllers/share.dart';
import 'package:futminna_project_1/extension/screen.dart';
import 'package:futminna_project_1/models/property.dart';
import 'package:futminna_project_1/screens/property/list.dart';
import 'package:futminna_project_1/utils/common.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController mapController;
  late BitmapDescriptor customIcon;
  Set<Polyline> _polylines = {};

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Position? userPosition;

  MapController? controller;

  bool mapPermission = false;

  ServiceModel? service;

  @override
  void initState() {
    super.initState();

    _requestMapPermission().then((value) {
      if (value) {
        _currentLocation().then((value) {
          userPosition = value;
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onClickMarker(ServiceModel data) {
    service = data;
    setPolylines();
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

  clearLocation() {
    polylineCoordinates = [];
    _polylines = {};
    setState(() {});
  }

  setPolylines() async {
    try {
      // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      //     "AIzaSyAYbyhtGqlePE6tJa8uNHmcwV25IQHef6U",
      //     PointLatLng(
      //       userPosition!.latitude,
      //       userPosition!.longitude,
      //     ),
      //     PointLatLng(double.tryParse(service!.latitude!) ?? 0,
      //         double.tryParse(service!.longitude!) ?? 0));
      // if (result.points.isNotEmpty) {
      //   for (var point in result.points) {
      polylineCoordinates.addAll([
        LatLng(
          userPosition!.latitude,
          userPosition!.longitude,
        ),
        LatLng(double.tryParse(service!.latitude!) ?? 0,
            double.tryParse(service!.longitude!) ?? 0)
      ]);
      //   }
      // }
      setState(() {
        Polyline polyline = Polyline(
            polylineId: PolylineId(service!.toString()),
            color: Commons.primaryColor,
            points: polylineCoordinates);

        _polylines.add(polyline);
      });
    } catch (e) {
      //
    }
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
      final ppData = ref.watch(propertyController);
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
                      if (auth.user?.email == 'abubakradisa@gmail.com') ...[
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PropertyList()));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: context.screenWidth(1),
                            height: 50,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                  'My Services',
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
                      ],
                      const SizedBox(
                        height: 30,
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
                            return const Center(
                                child: Text("Failed to get user location."));
                          } else {
                            Position? snapshotData = snapshot.data;
                            LatLng userLocation = LatLng(
                                snapshotData!.latitude, snapshotData.longitude);

                            return GoogleMap(
                              zoomControlsEnabled: false,
                              mapToolbarEnabled: false,
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: userLocation,
                                zoom: 12,
                              ),
                              polylines: _polylines,
                              mapType: MapType.normal,
                              markers: ppData.maps(
                                  BitmapDescriptor.defaultMarker, onClickMarker)
                                ..add(Marker(
                                    markerId: const MarkerId("My Location"),
                                    //icon: customIcon,
                                    infoWindow: InfoWindow(
                                        title: auth.user?.fullName ?? ''),
                                    position: userLocation)),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: InkWell(
                            onTap: () => scaffoldKey.currentState?.openDrawer(),
                            child: const CircleAvatar(
                              backgroundColor: Commons.primaryColor,
                              radius: 20,
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        if (service != null)
                          Container(
                            width: context.screenWidth(1),
                            height: context.screenHeight(0.3),
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      clearLocation();
                                    },
                                    child: const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Commons.primaryColor,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFFFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF000000)
                                                      .withOpacity(0.05),
                                                  spreadRadius: 0,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 0),
                                                ),
                                              ]),
                                          width: 100,
                                          height: 100,
                                          child: service!
                                                  .featuredImage!.isNotEmpty
                                              ? Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  8)),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: CachedNetworkImageProvider(
                                                              service!
                                                                  .featuredImage!))),
                                                )
                                              : const Icon(
                                                  Icons.location_on,
                                                  size: 60,
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
                                            service!.name!,
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
                                            service!.location!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          RatingBarIndicator(
                                            rating:
                                                service?.rating!.toDouble() ??
                                                    1,
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              Icons.star,
                                              color: Commons.primaryColor,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            direction: Axis.horizontal,
                                          ),
                                          if (userPosition != null)
                                            Text(
                                              '${calculateDistance(double.parse(service!.latitude!), double.parse(service!.longitude!), double.parse(userPosition!.latitude.toString()), double.parse(userPosition!.longitude.toString()))}km Away',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      fontSize: 14,
                                                      color:
                                                          Commons.primaryColor),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    final Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: service!.phoneNumber ?? '',
                                    );
                                    await launchUrl(launchUri);
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
                                      'Call now',
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
                          )
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
                                'Allow the app to locate your location\nto find the services near you',
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
