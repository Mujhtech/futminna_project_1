import 'package:flutter/material.dart';
import 'package:futminna_project_1/controllers/auth.dart';
import 'package:futminna_project_1/controllers/property.dart';
import 'package:futminna_project_1/screens/property/add.dart';
import 'package:futminna_project_1/screens/widgets/property_card.dart';
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
        body: property.filterByUser(auth.user!.uid!).isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.only(
                    bottom: 20.0, top: 5.0, left: 20, right: 20),
                itemCount: property.filterByUser(auth.user!.uid!).length,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (1 / 1.1),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final p = property.filterByUser(auth.user!.uid!)[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PropertyAdd(property: p)));
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
