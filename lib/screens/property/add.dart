import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:futminna_project_1/controllers/auth.dart';
import 'package:futminna_project_1/controllers/property.dart';
import 'package:futminna_project_1/extension/screen.dart';
import 'package:futminna_project_1/models/property.dart';
import 'package:futminna_project_1/repositories/connectivity.dart';
import 'package:futminna_project_1/utils/common.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rating_dialog/rating_dialog.dart';

class PropertyAdd extends StatefulWidget {
  final ServiceModel? property;
  const PropertyAdd({super.key, this.property});

  @override
  State<PropertyAdd> createState() => _PropertyAddState();
}

class _PropertyAddState extends State<PropertyAdd> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String category = 'Other';
  final ImagePicker _picker = ImagePicker();
  double rating = 1;

  final List<String> categories = [
    'Mechanic',
    'Hospital',
    'Filling Station',
    'Other'
  ];

  init() {
    if (widget.property != null) {
      title = TextEditingController(text: widget.property?.name ?? '');
      location = TextEditingController(text: widget.property?.location ?? '');
      description = TextEditingController(text: widget.property?.about ?? '');

      phoneNumber =
          TextEditingController(text: widget.property?.phoneNumber ?? '');

      lantitude = double.tryParse(widget.property?.latitude ?? '');
      longitude = double.tryParse(widget.property?.longitude ?? '');
      rating = widget.property?.rating?.toDouble() ?? 1;

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  File? bannerImage;
  File? featuredImage;
  double? lantitude, longitude;

  ImageProvider bannerImageProvider() {
    if (bannerImage != null) {
      return FileImage(bannerImage!);
    } else if (widget.property != null &&
        widget.property!.bannerImage != null &&
        widget.property!.bannerImage!.isNotEmpty) {
      return CachedNetworkImageProvider(widget.property!.bannerImage!);
    } else {
      return const CachedNetworkImageProvider(
          "https://via.placeholder.com/150");
    }
  }

  ImageProvider? featuredImageProvider() {
    if (featuredImage != null) {
      return FileImage(featuredImage!);
    } else if (widget.property != null &&
        widget.property!.featuredImage != null &&
        widget.property!.featuredImage!.isNotEmpty) {
      return CachedNetworkImageProvider(widget.property!.featuredImage!);
    } else {
      return null;
    }
  }

  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final pp = ref.watch(propertyController);
      final auth = ref.watch(authControllerProvider);
      final connect = ref.watch(connectivityController);

      final ratingDialog = RatingDialog(
        initialRating: rating,
        title: Text('Rating',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1),
        message: Text(
          'Tap a star to set your rating.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        enableComment: false,
        submitButtonText: 'Submit',
        submitButtonTextStyle: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Commons.primaryColor, fontWeight: FontWeight.w600),
        onCancelled: () {
          //print('cancelled');
        },
        onSubmitted: (response) async {
          rating = response.rating;
          setState(() {});
        },
      );

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            '${widget.property != null ? 'Edit' : 'Add new'} data',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () async {
                if (!await Commons.checkStoragePermission()) {
                  if (!await Commons.requestStoragePermission()) {
                    return;
                  }
                }
                try {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image!.name.isNotEmpty) {
                    setState(() {
                      bannerImage = File(image.path);
                    });
                  }
                } catch (err) {
                  //print(err.toString());
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: context.screenWidth(1),
                    height: 160,
                    padding: const EdgeInsets.all(50),
                    decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        image: DecorationImage(
                            fit: BoxFit.cover, image: bannerImageProvider())),
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: const Color(0xFFFFFFFF),
                          ),
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: () async {
                              if (!await Commons.checkStoragePermission()) {
                                if (!await Commons.requestStoragePermission()) {
                                  return;
                                }
                              }
                              try {
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image!.name.isNotEmpty) {
                                  setState(() {
                                    bannerImage = File(image.path);
                                  });
                                }
                              } catch (err) {
                                //print(err.toString());
                              }
                            },
                            child: const Center(
                              child: Icon(
                                Icons.photo_camera,
                                size: 20,
                                color: Color(0xFFCCCCCC),
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 0, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Form(
                      key: formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 70),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.05),
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ]),
                              width: 105,
                              height: 105,
                              child: GestureDetector(
                                onTap: () async {
                                  if (!await Commons.checkStoragePermission()) {
                                    if (!await Commons
                                        .requestStoragePermission()) {
                                      return;
                                    }
                                  }
                                  try {
                                    final XFile? image = await _picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (image!.name.isNotEmpty) {
                                      setState(() {
                                        featuredImage = File(image.path);
                                      });
                                    }
                                  } catch (err) {
                                    //print(err.toString());
                                  }
                                },
                                child: featuredImageProvider() != null
                                    ? Image(
                                        image: featuredImageProvider()!,
                                        width: 200,
                                        height: 200,
                                      )
                                    : const Icon(
                                        Icons.photo_camera,
                                        size: 50,
                                        color: Color(0xFFCCCCCC),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Add Details',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'Name Field is required';
                              }
                              return null;
                            },
                            controller: title,
                            cursorColor: Commons.primaryColor,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14),
                            decoration: InputDecoration(
                              enabledBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              focusedBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              focusedErrorBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              hintText: 'Name',
                              hintStyle:
                                  const TextStyle(color: Color(0xFFAAAAAA)),
                              errorBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.red),
                              fillColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              filled: true,
                            ),
                            autocorrect: false,
                            autofocus: false,
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'Phone Number Field is required';
                              }
                              return null;
                            },
                            controller: phoneNumber,
                            cursorColor: Commons.primaryColor,
                            keyboardType: TextInputType.phone,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14),
                            decoration: InputDecoration(
                              enabledBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              focusedBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              focusedErrorBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              hintText: 'Phone Number',
                              hintStyle:
                                  const TextStyle(color: Color(0xFFAAAAAA)),
                              errorBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.red),
                              fillColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              filled: true,
                            ),
                            autocorrect: false,
                            autofocus: false,
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'Location Field is required';
                              }
                              return null;
                            },
                            onChanged: (value) async {
                              if (value.isEmpty) return;
                              try {
                                List<Location> locations =
                                    await locationFromAddress(value);
                                Location location = locations[0];
                                setState(() {
                                  lantitude = location.latitude;
                                  longitude = location.longitude;
                                });
                              } catch (err) {
                                //print(err.toString());
                              }
                            },
                            controller: location,
                            cursorColor: Commons.primaryColor,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14),
                            decoration: InputDecoration(
                              enabledBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              focusedBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              focusedErrorBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              hintText: 'Location',
                              hintStyle:
                                  const TextStyle(color: Color(0xFFAAAAAA)),
                              errorBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.red),
                              fillColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              filled: true,
                            ),
                            autocorrect: false,
                            autofocus: false,
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'Description Field is required';
                              }
                              return null;
                            },
                            controller: description,
                            cursorColor: Commons.primaryColor,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14),
                            decoration: InputDecoration(
                              enabledBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              focusedBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              focusedErrorBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              hintText: 'About',
                              hintStyle:
                                  const TextStyle(color: Color(0xFFAAAAAA)),
                              errorBorder:
                                  Theme.of(context).inputDecorationTheme.border,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.red),
                              fillColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              filled: true,
                            ),
                            autocorrect: false,
                            autofocus: false,
                            obscureText: false,
                            maxLines: 5,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            width: context.screenWidth(1),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Category',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                DropdownButton<String>(
                                  // Initial Value
                                  value: category,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: categories.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  borderRadius: BorderRadius.circular(8),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      category = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => ratingDialog,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Add a review',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Commons.primaryColor)),
                                const SizedBox(
                                  width: 10,
                                ),
                                RatingBarIndicator(
                                  rating: rating.toDouble(),
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Commons.primaryColor,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (pp.loading)
                    const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Commons.primaryColor)),
                      ),
                    )
                  else
                    MaterialButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        if (!connect.connectivityStatus) {
                          const snackBar =
                              SnackBar(content: Text('No internet connection'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        if ((featuredImage == null ||
                                featuredImage!.path.isEmpty) &&
                            widget.property?.featuredImage == null) {
                          const snackBar = SnackBar(
                              content: Text('Please select featured image'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        try {
                          String featured = '';
                          String banner = '';

                          if (featuredImage != null) {
                            featured = await pp.uploadFile(featuredImage!);
                          } else {
                            featured = widget.property?.featuredImage ?? '';
                          }

                          if (bannerImage != null) {
                            banner = await pp.uploadFile(bannerImage!);
                          } else {
                            banner = widget.property?.bannerImage ?? '';
                          }

                          if (widget.property != null) {
                            await pp.update(
                                widget.property!.id,
                                auth.user!.uid!,
                                title.text.trim(),
                                category,
                                location.text.trim(),
                                phoneNumber.text.trim(),
                                lantitude!,
                                longitude!,
                                banner,
                                featured,
                                description.text.trim(),
                                rating: rating.toInt());
                          } else {
                            await pp.create(
                                auth.user!.uid!,
                                title.text.trim(),
                                category,
                                location.text.trim(),
                                phoneNumber.text.trim(),
                                lantitude!,
                                longitude!,
                                featured,
                                banner,
                                description.text.trim(),
                                rating: rating.toInt());
                          }

                          clearForm();
                          showGeneralDialog(
                            barrierLabel: "Barrier",
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            context: context,
                            pageBuilder: (_, __, ___) {
                              return Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 283,
                                  width: 293,
                                  margin: const EdgeInsets.only(
                                      bottom: 50, left: 12, right: 12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: SizedBox.expand(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 75,
                                        width: 75,
                                        decoration: BoxDecoration(
                                          color: Commons.primaryColor
                                              .withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Commons.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          'Successful',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          'Your data has been ${widget.property != null ? 'updated' : 'addedd'}\nsuccessfully',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(fontSize: 14),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Return Home',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    fontSize: 18,
                                                    color:
                                                        Commons.primaryColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              );
                            },
                            transitionBuilder: (_, anim, __, child) {
                              return SlideTransition(
                                position: Tween(
                                        begin: const Offset(0, 1),
                                        end: const Offset(0, 0))
                                    .animate(anim),
                                child: child,
                              );
                            },
                          );
                       
                        } catch (err) {
                          //
                        }
                      },
                      elevation: 0,
                      color: Commons.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: context.screenWidth(1),
                        height: 56,
                        alignment: Alignment.center,
                        child: Text(
                          'Save',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Commons.whiteColor),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  clearForm() {
    title.clear();
    description.clear();
    phoneNumber.clear();
    location.clear();
  }
}
