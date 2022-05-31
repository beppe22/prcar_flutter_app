// ignore_for_file: avoid_print

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName, String uid) async {
    File file = File(filePath);
    try {
      await storage.ref('$uid/drivingLicenseData/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> uploadCarPic(
      String filePath, String fileName, String uid, String cid) async {
    File file = File(filePath);
    try {
      await storage.ref('$uid/$cid/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> uploadString(
      String stringPath, String stringName, String uid) async {
    try {
      await storage
          .ref('$uid/drivingLicenseData/$stringName')
          .putString(stringPath);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> downloadURL(String uid, String cid, String carImage) async {
    String downloadUrl =
        await storage.ref('$uid/$cid/$carImage').getDownloadURL();
    return downloadUrl;
  }
}
