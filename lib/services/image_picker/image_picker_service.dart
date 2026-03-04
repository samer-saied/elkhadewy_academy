// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:image_picker/image_picker.dart';
// import 'package:iteacher/core/exceptions/convert_image_base_64_exception.dart';
// import 'package:iteacher/core/exceptions/pick_image_exception.dart';

// class ImagePickerService {
//   final ImagePicker _picker = ImagePicker();

//   Future<File> pickImageFromGallery() async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 800,
//       maxHeight: 800,
//       imageQuality: 85,
//     );
//     if (pickedFile?.path != null) {
//       return File(pickedFile!.path);
//     } else {
//       throw PickGalleryImageException();
//     }
//   }

//   Future<File> pickImageFromCamera() async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.camera,
//       maxWidth: 800,
//       maxHeight: 800,
//       imageQuality: 85,
//     );

//     if (pickedFile?.path != null) {
//       return File(pickedFile!.path);
//     } else {
//       throw PickCameraImageException();
//     }
//   }

//   Future<List<File>> pickMultipleImages() async {
//     final List<XFile> pickedFiles = await _picker.pickMultiImage(
//       maxWidth: 800,
//       maxHeight: 800,
//       imageQuality: 85,
//     );
//     if (pickedFiles.isNotEmpty) {
//       return pickedFiles.map((xFile) => File(xFile.path)).toList();
//     } else {
//       throw PickMultiImageException();
//     }
//   }

//   Future<String> convertImageToBase64(File imageFile) async {
//     try {
//       final Uint8List bytes = await imageFile.readAsBytes();
//       return base64Encode(bytes);
//     } catch (e) {
//       throw ConvertImageToBase64Exception();
//     }
//   }

//   Future<String> pickImageAsBase64FromGallery() async {
//     final File imageFile = await pickImageFromGallery();
//     return await convertImageToBase64(imageFile);
//   }

//   Future<String> pickImageAsBase64FromCamera() async {
//     final File imageFile = await pickImageFromCamera();
//     return await convertImageToBase64(imageFile);
//   }

//   Future<List<String>> pickMultipleImagesAsBase64() async {
//     final List<File> imageFiles = await pickMultipleImages();
//     final List<String> base64Images = [];

//     for (File imageFile in imageFiles) {
//       final String base64String = await convertImageToBase64(imageFile);
//       base64Images.add(base64String);
//     }
//     return base64Images;
//   }
// }
// class PickCameraImageException implements Exception {}

// class PickGalleryImageException implements Exception {}

// class PickMultiImageException implements Exception {}
