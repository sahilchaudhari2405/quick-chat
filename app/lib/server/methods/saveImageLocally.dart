import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageStore {
  Future<String> saveImageLocally(File imageFile) async {
    try {
      // Get the app's document directory using path_provider package
      Directory appDocDir = await getApplicationDocumentsDirectory();

      // Create a new directory (optional) in the app's documents directory
      // This step is optional, you can skip it if you want to save directly in the documents directory
      Directory appDocDirNewFolder =
          await Directory('${appDocDir.path}/Images').create(recursive: true);

      // Define a file path for the image
      String filePath =
          '${appDocDirNewFolder.path}/${DateTime.now().millisecondsSinceEpoch}.png';

      // Write the file to the local file system
      await imageFile.copy(filePath);

      // Return the file path where the image has been saved
      return filePath;
    } catch (e) {
      print('Error saving image locally: $e');
      return ''; // Return empty string or handle the error as per your app's requirement
    }
  }

  Future<File> decodeBase64ToFile(String base64String, String fileName) async {
    try {
      // Decode the base64 string to bytes
      List<int> imageBytes = base64Decode(base64String);

      // Get the app's document directory using path_provider package
      Directory appDocDir = await getApplicationDocumentsDirectory();

      // Create the file
      File file = File('${appDocDir.path}/$fileName');

      // Write the bytes to the file
      await file.writeAsBytes(imageBytes);

      return file;
    } catch (e) {
      print('Error decoding base64 and saving file: $e');
      throw e; // Optionally rethrow the error for handling elsewhere
    }
  }

  Future<File> handleReceivedData(String base64Image) async {
    try {
      // Decode base64 string to File
      File imageFile =
          await decodeBase64ToFile(base64Image, 'received_image.png');

      // Save image locally and get the saved file path
      String savedImagePath = await saveImageLocally(imageFile);

      // Return the File object so it can be used to display the image
      return File(savedImagePath);
    } catch (e) {
      print('Error decoding base64 and saving file: $e');
      throw e; // Rethrow the exception or handle it as per your app's requirement
    }
  }
}
