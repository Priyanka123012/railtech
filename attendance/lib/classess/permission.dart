import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  AppPermissions._();

  static final AppPermissions _instance = AppPermissions._();
  static AppPermissions get instance => _instance;

  bool camera = false;
  bool location = false;
  bool readStorage = false;

  bool get isAllAccepted => ![camera, readStorage, location].contains(false);
  Future<void> checkAllPermissions() async {
    final resp = await [
      Permission.storage,
      Permission.photos,
      // Permission.manageExternalStorage,
      Permission.location,
      Permission.camera,
    ].request();

    camera = resp[Permission.camera]!.isGranted;
    location = resp[Permission.location]!.isGranted;
    readStorage = [
      resp[Permission.storage]?.isGranted,
      resp[Permission.photos]?.isGranted
    ].contains(true);
  }

  Future<bool> checkStoragePermission() async {
    readStorage = await Permission.storage.isGranted;
    if (!readStorage) {
      readStorage = ((await Permission.storage.request()).isGranted ||
          (await Permission.photos.request()).isGranted);
    }
    return readStorage;
  }

  Future<bool> checkCameraPermission() async {
    camera = await Permission.camera.isGranted;
    if (!camera) {
      camera = (await Permission.camera.request()).isGranted;
    }
    return camera;
  }

  Future<bool> checkLocationPermission() async {
    try {
      location = await Permission.location.isGranted;
      if (!await Permission.location.isGranted) {
        location = (await Permission.location.request()).isGranted;
      }
      return location;
    } catch (e) {
      return false;
    }
  }
}

// final _defaulapppath = "storage/emulated/0/DivyangjanApp";
// final _defaulapprecordpath = "storage/emulated/0/DivyangjanApp/Recording";
// final _defaulappdownpath = "storage/emulated/0/DivyangjanApp/Download";
