// ignore_for_file: must_be_immutable, no_logic_in_create_state
import 'package:flutter/material.dart';

class Album extends StatefulWidget {
  String uid, cid, files;
  Album({Key? key, required this.uid, required this.cid, required this.files})
      : super(key: key);

  @override
  State<Album> createState() => _AlbumState(uid, cid, files);
}

class _AlbumState extends State<Album> {
  String? uid, cid, files;
  _AlbumState(uid, cid, files);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Car\'s picture'),
            backgroundColor: Colors.redAccent,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: const Center(child: CircularProgressIndicator()));
  }
}
