// ignore_for_file: must_be_immutable, no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class Album extends StatelessWidget {
  List<String> files;
  Album({Key? key, required this.files}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text("Fuel"),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                })),
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                  height: 250,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              GestureDetector(
                  onTap: () async {
                    final List<ImageProvider> _imageProviders = [];
                    for (int i = 0; i < files.length; i++) {
                      _imageProviders.insert(i, Image.network(files[i]).image);
                    }
                    MultiImageProvider multiImageProvider =
                        MultiImageProvider(_imageProviders);
                    await showImageViewerPager(context, multiImageProvider);
                  },
                  child: Container(
                      width: double.maxFinite,
                      height: 50,
                      margin: const EdgeInsets.only(
                          top: 15, left: 40, right: 40, bottom: 15),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                          child: Text("Show Picture",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))))
            ]));
  }
}
