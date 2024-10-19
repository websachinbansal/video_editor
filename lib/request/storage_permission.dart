import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  await Permission.manageExternalStorage.request();
  // await Permission.storage.request();
  var status = await Permission.manageExternalStorage.status;

  // If permission is not granted, request it
  if (status.isDenied || status.isRestricted) {
    await openAppSettings();
  }

  // Handle different permission states
  if (status.isPermanentlyDenied) {
    // Open app settings if permission is permanently denied
    await openAppSettings();
    throw Exception(
        "Storage permission permanently denied. Please enable it in app settings.");
  } else if (status.isDenied) {
    throw Exception("Storage permission denied. Cannot download video.");
  } else if (status.isGranted) {
    // Permission is granted, proceed with your operations
    print("Storage permission granted.");
  } else {
    throw Exception("Storage permission is required to proceed.");
  }
}
