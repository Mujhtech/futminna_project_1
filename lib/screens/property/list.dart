import 'package:flutter/material.dart';
import 'package:futminna_project_1/controllers/auth.dart';
import 'package:futminna_project_1/controllers/property.dart';
import 'package:futminna_project_1/screens/property/add.dart';
import 'package:futminna_project_1/screens/widgets/property_card.dart';
import 'package:futminna_project_1/utils/common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PropertyList extends StatefulWidget {
  const PropertyList({super.key});

  @override
  State<PropertyList> createState() => _PropertyListState();
}

class _PropertyListState extends State<PropertyList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final auth = ref.watch(authControllerProvider);
      final property = ref.watch(propertyController);
      return Scaffold(
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
            'My Datas',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: property.properties != null && property.properties!.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.only(
                    bottom: 20.0, top: 5.0, left: 20, right: 20),
                itemCount: property.properties!.length,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (1 / 1.1),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final p = property.properties![index];
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PropertyAdd(property: p)));
                                    },
                                    child: Text(
                                      'Edit',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await property.delete(p.id);
                                      showGeneralDialog(
                                        barrierLabel: "Barrier",
                                        barrierDismissible: true,
                                        barrierColor:
                                            Colors.black.withOpacity(0.5),
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
                                                  bottom: 50,
                                                  left: 12,
                                                  right: 12),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: SizedBox.expand(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 75,
                                                    width: 75,
                                                    decoration: BoxDecoration(
                                                      color: Commons
                                                          .primaryColor
                                                          .withOpacity(0.05),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: const Icon(
                                                      Icons.check,
                                                      color:
                                                          Commons.primaryColor,
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      'Service deleted successfully',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              fontSize: 14),
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
                                                        'Go back',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                fontSize: 18,
                                                                color: Commons
                                                                    .primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                            ),
                                          );
                                        },
                                        transitionBuilder:
                                            (_, anim, __, child) {
                                          return SlideTransition(
                                            position: Tween(
                                                    begin: const Offset(0, 1),
                                                    end: const Offset(0, 0))
                                                .animate(anim),
                                            child: child,
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      'Delete',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: PropertyCard(
                      page: 1,
                      title: p.name!,
                      bannerImage: p.featuredImage!,
                    ),
                  );
                })
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.place,
                      size: 150,
                      color: Color(0xFFCCCCCC),
                    ),
                    Text(
                      'No data found!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PropertyAdd()),
          ),
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.add,
            size: 20,
            color: Colors.white,
          ),
        ),
      );
    });
  }
}
