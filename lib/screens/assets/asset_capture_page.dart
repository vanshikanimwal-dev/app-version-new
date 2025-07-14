// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io'; // Required for File class (if displaying images from path)
// // import 'dart:async';
// // import 'dart:ui'; // For ImageFilter.blur
// //
// // import 'package:ferrero_asset_management/widgets/styled_button.dart';
// // import 'package:ferrero_asset_management/widgets/photo_capture_grid_item.dart';
// // import 'package:ferrero_asset_management/widgets/location_grid_item.dart';
// // import 'package:ferrero_asset_management/screens/consent/consent_and_otp_verification_page.dart';
// //
// // class AssetCapturePage extends StatefulWidget {
// //   final String outletName;
// //   final String outletOwnerNumber;
// //   final String username;
// //   final Map<String, String?> capturedImages; // Now expecting resolved paths
// //   final String? capturedLocation;
// //
// //   const AssetCapturePage({
// //     super.key,
// //     required this.outletName,
// //     required this.outletOwnerNumber,
// //     required this.username,
// //     this.capturedImages = const {},
// //     this.capturedLocation,
// //   });
// //
// //   @override
// //   State<AssetCapturePage> createState() => _AssetCapturePageState();
// // }
// //
// // class _AssetCapturePageState extends State<AssetCapturePage> {
// //   Position? _currentPosition;
// //   String _locationMessage = 'Tap to get location';
// //   bool _isLocationFetching = false;
// //
// //   final ImagePicker _picker = ImagePicker();
// //
// //   final Map<String, String?> _resolvedImagePaths = {
// //     'outlet_exteriors_photo': null,
// //     'asset_pics': null,
// //     'outlet_owner_ids_pics': null,
// //     'outlet_owner_pic': null,
// //     'serial_no_pic': null,
// //   };
// //
// //   bool get _allPhotosCaptured {
// //     bool allImagesCaptured = _resolvedImagePaths.values.every((path) => path != null);
// //     bool locationCaptured = _currentPosition != null;
// //     return allImagesCaptured && locationCaptured;
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     widget.capturedImages.forEach((key, path) {
// //       if (path != null) {
// //         _resolvedImagePaths[key] = path;
// //       }
// //     });
// //
// //     if (widget.capturedLocation != null && widget.capturedLocation!.startsWith('Lat:')) {
// //       final parts = widget.capturedLocation!.split(', ');
// //       if (parts.length == 2) {
// //         final lat = double.tryParse(parts[0].replaceFirst('Lat: ', ''));
// //         final lng = double.tryParse(parts[1].replaceFirst('Lng: ', ''));
// //         if (lat != null && lng != null) {
// //           _currentPosition = Position(
// //             latitude: lat,
// //             longitude: lng,
// //             timestamp: DateTime.now(),
// //             accuracy: 0.0,
// //             altitude: 0.0,
// //             heading: 0.0,
// //             speed: 0.0,
// //             speedAccuracy: 0.0,
// //             altitudeAccuracy: 0.0,
// //             headingAccuracy: 0.0,
// //           );
// //           _locationMessage = 'Location already captured!';
// //         }
// //       }
// //     }
// //   }
// //
// //   Future<void> _requestLocationPermission() async {
// //     setState(() {
// //       _isLocationFetching = true;
// //       _locationMessage = 'Checking permissions...';
// //       _currentPosition = null;
// //     });
// //
// //     LocationPermission permission = await Geolocator.requestPermission();
// //
// //     if (permission == LocationPermission.denied) {
// //       _showSnackBar('Location permission was denied. Please grant access to capture location.', isError: true);
// //       setState(() {
// //         _isLocationFetching = false;
// //         _locationMessage = 'Location permission denied.';
// //       });
// //       return;
// //     }
// //
// //     if (permission == LocationPermission.deniedForever) {
// //       _showSnackBar('Location permission is permanently denied. Please enable from app settings.', isError: true);
// //       setState(() {
// //         _isLocationFetching = false;
// //         _locationMessage = 'Location permission permanently denied.';
// //       });
// //       await Geolocator.openAppSettings();
// //       return;
// //     }
// //
// //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) {
// //       _showSnackBar('Location services are disabled. Please enable them to capture location.', isError: true);
// //       setState(() {
// //         _isLocationFetching = false;
// //         _locationMessage = 'Location services are disabled.';
// //       });
// //       await Geolocator.openLocationSettings();
// //       return;
// //     }
// //
// //     _getCurrentLocation();
// //   }
// //
// //   Future<void> _getCurrentLocation() async {
// //     try {
// //       Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high,
// //         timeLimit: const Duration(seconds: 10),
// //       );
// //       setState(() {
// //         _currentPosition = position;
// //         _locationMessage = 'Location captured!';
// //       });
// //       // Removed success SnackBar for location capture
// //     } on TimeoutException {
// //       setState(() {
// //         _locationMessage = 'Failed to get location: Timeout.';
// //         _currentPosition = null;
// //       });
// //       _showSnackBar('Failed to get location: Timeout. Please try again.', isError: true);
// //     } catch (e) {
// //       setState(() {
// //         _locationMessage = 'Failed to get location: $e';
// //         _currentPosition = null;
// //       });
// //       _showSnackBar('Failed to get location: $e', isError: true);
// //     } finally {
// //       setState(() {
// //         _isLocationFetching = false;
// //       });
// //     }
// //   }
// //
// //   Future<void> _determinePosition() async {
// //     await _requestLocationPermission();
// //   }
// //
// //   Future<void> _pickImage(String imageType) async {
// //     try {
// //       final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
// //       if (photo != null) {
// //         final String filePath = photo.path;
// //
// //         if (File(filePath).existsSync()) {
// //           setState(() {
// //             _resolvedImagePaths[imageType] = filePath;
// //           });
// //           // Removed success SnackBar for photo capture
// //           print('DEBUG: Directly using XFile.path for $imageType: $filePath');
// //         } else {
// //           _showSnackBar('Captured photo file not found at path: $filePath. Please try again.', isError: true);
// //           print('ERROR: Captured photo file does not exist at path: $filePath');
// //         }
// //       } else {
// //         // Removed SnackBar for photo capture cancellation, as it's not an error
// //       }
// //     } catch (e) {
// //       _showSnackBar('Error picking photo for $imageType: $e', isError: true);
// //       print('ERROR: Exception during photo picking for $imageType: $e');
// //     }
// //   }
// //
// //   void _proceedToConsent() {
// //     if (_allPhotosCaptured) {
// //       // Removed success SnackBar for proceeding
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => ConsentAndOtpVerificationPage(
// //             outletOwnerNumber: widget.outletOwnerNumber,
// //             outletName: widget.outletName,
// //             username: widget.username,
// //             capturedImages: _resolvedImagePaths.cast<String, String?>(), // Pass the resolved paths
// //             capturedLocation: _currentPosition != null
// //                 ? 'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}'
// //                 : null,
// //           ),
// //         ),
// //       );
// //     } else {
// //       _showSnackBar('Please capture all required photos and location before proceeding to consent.', isError: true);
// //     }
// //   }
// //
// //   void _showSnackBar(String message, {bool isError = false}) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         backgroundColor: isError ? Colors.red : Colors.green,
// //         duration: const Duration(seconds: 3),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFFAF6EF),
// //       body: Stack(
// //         children: [
// //           SingleChildScrollView(
// //             child: Padding(
// //               padding: const EdgeInsets.all(20.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
// //                     child: GestureDetector(
// //                       onTap: () => Navigator.pop(context),
// //                       child: const Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
// //                           Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 15),
// //                   ClipRect(
// //                     child: BackdropFilter(
// //                       filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
// //                       child: Container(
// //                         height: 1.0,
// //                         decoration: BoxDecoration(
// //                           color: Colors.brown.withOpacity(0.2),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black.withOpacity(0.1),
// //                               blurRadius: 5.0,
// //                               offset: const Offset(0, 3),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   Text(
// //                     'Current Outlet: ${widget.outletName}',
// //                     style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   GridView.count(
// //                     shrinkWrap: true,
// //                     physics: const NeverScrollableScrollPhysics(),
// //                     crossAxisCount: 2,
// //                     crossAxisSpacing: 20.0,
// //                     mainAxisSpacing: 20.0,
// //                     children: [
// //                       PhotoCaptureGridItem(
// //                         imageType: 'outlet_exteriors_photo',
// //                         label: 'Outlet Exteriors Photo',
// //                         pickedFile: _resolvedImagePaths['outlet_exteriors_photo'] != null
// //                             ? XFile(_resolvedImagePaths['outlet_exteriors_photo']!)
// //                             : null,
// //                         onTap: () => _pickImage('outlet_exteriors_photo'),
// //                       ),
// //                       PhotoCaptureGridItem(
// //                         imageType: 'asset_pics',
// //                         label: 'Asset Photos',
// //                         pickedFile: _resolvedImagePaths['asset_pics'] != null
// //                             ? XFile(_resolvedImagePaths['asset_pics']!)
// //                             : null,
// //                         onTap: () => _pickImage('asset_pics'),
// //                       ),
// //                       PhotoCaptureGridItem(
// //                         imageType: 'outlet_owner_ids_pics',
// //                         label: 'Outlet Owner ID\'s Photos',
// //                         pickedFile: _resolvedImagePaths['outlet_owner_ids_pics'] != null
// //                             ? XFile(_resolvedImagePaths['outlet_owner_ids_pics']!)
// //                             : null,
// //                         onTap: () => _pickImage('outlet_owner_ids_pics'),
// //                       ),
// //                       PhotoCaptureGridItem(
// //                         imageType: 'outlet_owner_pic',
// //                         label: 'Outlet Owner\'s Photo',
// //                         pickedFile: _resolvedImagePaths['outlet_owner_pic'] != null
// //                             ? XFile(_resolvedImagePaths['outlet_owner_pic']!)
// //                             : null,
// //                         onTap: () => _pickImage('outlet_owner_pic'),
// //                       ),
// //                       PhotoCaptureGridItem(
// //                         imageType: 'serial_no_pic',
// //                         label: 'Serial Number Photo',
// //                         pickedFile: _resolvedImagePaths['serial_no_pic'] != null
// //                             ? XFile(_resolvedImagePaths['serial_no_pic']!)
// //                             : null,
// //                         onTap: () => _pickImage('serial_no_pic'),
// //                       ),
// //                       LocationGridItem(
// //                         isFetching: _isLocationFetching,
// //                         message: _locationMessage,
// //                         currentPosition: _currentPosition,
// //                         onTap: _determinePosition,
// //                         isLocationCaptured: _currentPosition != null,
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 40),
// //                   Center(
// //                       child: styledButton(
// //                           text: 'Proceed to Consent',
// //                           onPressed: _proceedToConsent
// //                       )
// //                   ),
// //                   const SizedBox(height: 20),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart'; // Make sure you have geolocator in pubspec.yaml
// import 'package:provider/provider.dart';
// import 'package:ferrero_asset_management/provider/data_provider.dart';
// import 'package:ferrero_asset_management/widgets/styled_button.dart';
// import 'package:ferrero_asset_management/widgets/photo_capture_grid_item.dart'; // Import the new widget
// import 'package:http/http.dart' as http; // For API calls (if submitting)
// import 'dart:convert'; // For JSON encoding/decoding
//
// class AssetCapturePage extends StatefulWidget {
//   final String outletName;
//   final String outletOwnerNumber;
//   final String username;
//   final Map<String, String?> capturedImages; // Initial images (for completed shops)
//   final String? capturedLocation; // Initial location (for completed shops)
//   final bool isShopCompleted; // To determine read-only vs editable mode
//
//   const AssetCapturePage({
//     super.key,
//     required this.outletName,
//     required this.outletOwnerNumber,
//     required this.username,
//     required this.capturedImages,
//     required this.capturedLocation,
//     required this.isShopCompleted,
//   });
//
//   @override
//   State<AssetCapturePage> createState() => _AssetCapturePageState();
// }
//
// class _AssetCapturePageState extends State<AssetCapturePage> {
//   // Use a map to store paths for each image type
//   late Map<String, String?> _resolvedImagePaths;
//   String? _capturedLocation;
//   bool _isLoadingLocation = false;
//   late bool _isEditable; // Controls if the form is editable
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize with data passed from ConsentFormPage
//     _resolvedImagePaths = Map.from(widget.capturedImages);
//     _capturedLocation = widget.capturedLocation;
//     _isEditable = !widget.isShopCompleted; // If shop is completed, it's NOT editable
//   }
//
//   Future<void> _pickImage(String imageType) async {
//     if (!_isEditable) return; // Do nothing if not editable
//
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.camera);
//
//     if (image != null) {
//       setState(() {
//         _resolvedImagePaths[imageType] = image.path;
//         // Optionally update the DataProvider directly if you want it to always reflect the latest image
//         // Provider.of<DataProvider>(context, listen: false).updateNestedImage('captured_images', imageType, image.path);
//       });
//     }
//   }
//
//   Future<void> _getCurrentLocation() async {
//     if (!_isEditable) return; // Do nothing if not editable
//
//     setState(() {
//       _isLoadingLocation = true;
//     });
//
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           _showDialog('Location Permission Denied', 'Location permissions are denied. Please enable them in settings.');
//           return;
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         _showDialog('Location Permission Denied', 'Location permissions are permanently denied. Please enable them in settings.');
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       setState(() {
//         _capturedLocation = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
//         // Optionally update the DataProvider directly
//         // Provider.of<DataProvider>(context, listen: false).setLocation(_capturedLocation);
//       });
//     } catch (e) {
//       _showDialog('Error Getting Location', 'Could not get location: $e');
//     } finally {
//       setState(() {
//         _isLoadingLocation = false;
//       });
//     }
//   }
//
//   Future<void> _submitShopDetails() async {
//     if (!_isEditable) return; // Do nothing if not editable
//
//     // Basic validation: ensure all required images are captured
//     if (_resolvedImagePaths['outlet_exteriors_photo'] == null ||
//         _resolvedImagePaths['asset_pics'] == null ||
//         _resolvedImagePaths['outlet_owner_ids_pics'] == null ||
//         _resolvedImagePaths['outlet_owner_pic'] == null ||
//         _resolvedImagePaths['serial_no_pic'] == null) {
//       _showDialog('Missing Images', 'Please capture all required images before submitting.');
//       return;
//     }
//
//     if (_capturedLocation == null || _capturedLocation!.isEmpty) {
//       _showDialog('Missing Location', 'Please capture location before submitting.');
//       return;
//     }
//
//     // Get data from provider
//     final dataProvider = Provider.of<DataProvider>(context, listen: false);
//
//     // --- FIXED: Assemble the submission data map locally from DataProvider's getters ---
//     final Map<String, dynamic> submissionData = {
//       'UOC': dataProvider.uoc,
//       'OUTLET_NAME': dataProvider.outletNameFromConsentForm,
//       'Address': dataProvider.address,
//       'VC Type': dataProvider.vcType,
//       'VC Serial No': dataProvider.vcSerialNo,
//       'Contact_Person': dataProvider.contactPerson,
//       'Mobile Number': dataProvider.mobileNumberFromConsentForm,
//       'State': dataProvider.state,
//       'Postal Code': dataProvider.postalCode,
//       'Username': dataProvider.username, // Make sure username is set in DataProvider
//       'captured_images': _resolvedImagePaths, // Use the locally managed images from AssetCapturePage state
//       'captured_location': _capturedLocation, // Use the locally managed location from AssetCapturePage state
//       'Status': 'Completed', // Set the status upon submission
//       // Add any other fields you need from the DataProvider or local state
//     };
//     // ----------------------------------------------------------------------------------
//
//     print('Submitting data: $submissionData');
//
//     // --- IMPORTANT: Now, update the DataProvider with the current state before potentially navigating back ---
//     // This ensures that if you navigate back to ConsentFormPage and then forward again (without restarting app),
//     // the DataProvider correctly holds the newly captured data as if it was pre-existing for a 'Completed' shop.
//     // However, for a real app, this update should ideally happen after a successful API submission.
//     dataProvider.updateString('UOC', submissionData['UOC']);
//     dataProvider.updateString('OUTLET_NAME', submissionData['OUTLET_NAME']);
//     // ... continue for all other fields updated in ConsentFormPage ...
//     // For images and location, use your dedicated DataProvider methods:
//     dataProvider.addImages(submissionData['captured_images'] as Map<String, String?>);
//     dataProvider.setLocation(submissionData['captured_location'] as String?);
//     // If you have a 'setStatus' in DataProvider:
//     // dataProvider.setStatus('Completed');
//     dataProvider.finalizeAllUpdates(); // Call this to notify listeners after all updates
//
//
//     // Here you would typically send this data to your backend API
//     // For prototype, we'll just show a success message
//     try {
//       // Example API call (replace with your actual API service logic)
//       // final response = await http.post(
//       //   Uri.parse('YOUR_BACKEND_SUBMIT_URL'),
//       //   headers: {'Content-Type': 'application/json'},
//       //   body: json.encode(submissionData), // Use the newly assembled map
//       // );
//
//       // if (response.statusCode == 200) {
//       _showDialog('Submission Successful', 'Shop data submitted successfully!');
//       // Optionally clear data in provider after successful submission if starting completely fresh
//       // dataProvider.clearAllData();
//       // Navigate back to the previous screen (e.g., ConsentFormPage or list of shops)
//       Navigator.pop(context); // Go back to ConsentFormPage
//       // } else {
//       //   _showDialog('Submission Failed', 'Failed to submit data: ${response.statusCode}');
//       // }
//     } catch (e) {
//       _showDialog('Error', 'An error occurred during submission: $e');
//     }
//   }
//
//   void _showDialog(String title, String message) {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF6EF),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
//                     Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Capture Assets for: ${widget.outletName}',
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
//             ),
//             const SizedBox(height: 30),
//             // Location Section
//             Text(
//               'Location Details:',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _isEditable ? Colors.brown : Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.all(12.0),
//               decoration: BoxDecoration(
//                 color: _isEditable ? Colors.white : Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8.0),
//                 border: Border.all(color: Colors.brown, width: 1),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _capturedLocation ?? 'Location not captured',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: _capturedLocation != null ? Colors.black87 : Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   styledButton(
//                     text: _isLoadingLocation ? 'Getting Location...' : 'Get Location',
//                     onPressed: _isLoadingLocation || !_isEditable ? null : _getCurrentLocation,
//                     buttonColor: _isEditable ? Colors.brown : Colors.grey, // Grey out if not editable
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             // Photos Section
//             Text(
//               'Photo Capture:',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _isEditable ? Colors.brown : Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 15),
//             GridView.count(
//               crossAxisCount: 2, // Two items per row
//               shrinkWrap: true, // Take only necessary space
//               physics: const NeverScrollableScrollPhysics(), // Disable scrolling within grid
//               mainAxisSpacing: 15,
//               crossAxisSpacing: 15,
//               children: [
//                 PhotoCaptureGridItem(
//                   label: 'Outlet Exteriors Photo',
//                   pickedFilePath: _resolvedImagePaths['outlet_exteriors_photo'],
//                   onTap: () => _pickImage('outlet_exteriors_photo'),
//                   isEditable: _isEditable,
//                 ),
//                 PhotoCaptureGridItem(
//                   label: 'Asset Pics',
//                   pickedFilePath: _resolvedImagePaths['asset_pics'],
//                   onTap: () => _pickImage('asset_pics'),
//                   isEditable: _isEditable,
//                 ),
//                 PhotoCaptureGridItem(
//                   label: 'Outlet Owner ID\'s Pics',
//                   pickedFilePath: _resolvedImagePaths['outlet_owner_ids_pics'],
//                   onTap: () => _pickImage('outlet_owner_ids_pics'),
//                   isEditable: _isEditable,
//                 ),
//                 PhotoCaptureGridItem(
//                   label: 'Outlet Owner Pic',
//                   pickedFilePath: _resolvedImagePaths['outlet_owner_pic'],
//                   onTap: () => _pickImage('outlet_owner_pic'),
//                   isEditable: _isEditable,
//                 ),
//                 PhotoCaptureGridItem(
//                   label: 'Serial No. Pic',
//                   pickedFilePath: _resolvedImagePaths['serial_no_pic'],
//                   onTap: () => _pickImage('serial_no_pic'),
//                   isEditable: _isEditable,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 40),
//             Center(
//               child: styledButton(
//                 text: 'Submit Shop Details',
//                 onPressed: _isEditable ? _submitShopDetails : null, // Disable if not editable
//                 buttonColor: _isEditable ? Colors.brown : Colors.grey, // Grey out if not editable
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// In lib/screens/asset_capture_page.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ferrero_asset_management/provider/data_provider.dart';
import 'package:ferrero_asset_management/widgets/styled_button.dart';
import 'package:ferrero_asset_management/widgets/photo_capture_grid_item.dart';
import 'package:ferrero_asset_management/screens/consent/consent_and_otp_verification_page.dart';
// import 'package:ferrero_asset_management/screens/pdf_viewer/pdf_viewer_screen.dart'; // Make sure this import is correct
// In lib/screens/asset_capture_page.dart

// import 'package:ferrero_asset_management/screens/pdf_viewer/pdf_viewer_screen.dart'; // <--- REMOVE THIS
import 'package:ferrero_asset_management/screens/image_viewer/image_viewer_screen.dart'; // <--- ADD THIS
class AssetCapturePage extends StatefulWidget {
  final String outletName;
  final String outletOwnerNumber;
  final String username;
  final Map<String, String?> capturedImages;
  final String? capturedLocation;
  final bool isShopCompleted;

  const AssetCapturePage({
    super.key,
    required this.outletName,
    required this.outletOwnerNumber,
    required this.username,
    required this.capturedImages,
    required this.capturedLocation,
    required this.isShopCompleted,
  });

  @override
  State<AssetCapturePage> createState() => _AssetCapturePageState();
}

class _AssetCapturePageState extends State<AssetCapturePage> {
  late Map<String, String?> _resolvedImagePaths;
  String? _capturedLocation;
  bool _isLoadingLocation = false;
  late bool _isEditable;

  @override
  void initState() {
    super.initState();
    _resolvedImagePaths = Map.from(widget.capturedImages);
    _capturedLocation = widget.capturedLocation;
    _isEditable = !widget.isShopCompleted;
  }

  Future<void> _pickImage(String imageType) async {
    if (!_isEditable) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _resolvedImagePaths[imageType] = image.path;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!_isEditable) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showDialog('Location Permission Denied', 'Location permissions are denied. Please enable them in settings.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showDialog('Location Permission Denied', 'Location permissions are permanently denied. Please enable them in settings.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _capturedLocation = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
      });
    } catch (e) {
      _showDialog('Error Getting Location', 'Could not get location: $e');
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _submitShopDetails() async {
    if (!_isEditable) return;

    if (_resolvedImagePaths['outlet_exteriors_photo'] == null ||
        _resolvedImagePaths['asset_pics'] == null ||
        _resolvedImagePaths['outlet_owner_ids_pics'] == null ||
        _resolvedImagePaths['outlet_owner_pic'] == null ||
        _resolvedImagePaths['serial_no_pic'] == null) {
      _showDialog('Missing Images', 'Please capture all required images before initiating agreement.');
      return;
    }

    if (_capturedLocation == null || _capturedLocation!.isEmpty) {
      _showDialog('Missing Location', 'Please capture location before initiating agreement.');
      return;
    }

    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    final Map<String, dynamic> submissionData = {
      'UOC': dataProvider.uoc,
      'OUTLET_NAME': dataProvider.outletNameFromConsentForm,
      'Address': dataProvider.address,
      'VC Type': dataProvider.vcType,
      'VC Serial No': dataProvider.vcSerialNo,
      'Contact_Person': dataProvider.contactPerson,
      'Mobile Number': dataProvider.mobileNumberFromConsentForm,
      'State': dataProvider.state,
      'Postal Code': dataProvider.postalCode,
      'Username': dataProvider.username,
      'captured_images': _resolvedImagePaths,
      'captured_location': _capturedLocation,
      'Status': 'Pending_Agreement',
    };

    print('Attempting to initiate agreement with data: $submissionData');

    dataProvider.updateString('UOC', submissionData['UOC']);
    dataProvider.updateString('OUTLET_NAME', submissionData['OUTLET_NAME']);
    dataProvider.updateString('Address', submissionData['Address']);
    dataProvider.updateString('VC Type', submissionData['VC Type']);
    dataProvider.updateString('VC Serial No', submissionData['VC Serial No']);
    dataProvider.updateString('Contact_Person', submissionData['Contact_Person']);
    dataProvider.updateString('Mobile Number', submissionData['Mobile Number']);
    dataProvider.updateString('State', submissionData['State']);
    dataProvider.updateString('Postal Code', submissionData['Postal Code']);
    dataProvider.addImages(submissionData['captured_images'] as Map<String, String?>);
    dataProvider.setLocation(submissionData['captured_location'] as String?);
    dataProvider.finalizeAllUpdates();

    try {
      await _showDialog('Asset Data Captured!', 'Proceeding to consent and OTP verification.');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConsentAndOtpVerificationPage(
            outletName: dataProvider.outletNameFromConsentForm ?? widget.outletName,
            outletOwnerNumber: dataProvider.mobileNumberFromConsentForm ?? widget.outletOwnerNumber,
            username: dataProvider.username ?? widget.username,
            capturedImages: _resolvedImagePaths,
            capturedLocation: _capturedLocation,
          ),
        ),
      );
    } catch (e) {
      _showDialog('Error', 'An error occurred: $e');
    }
  }

  // In lib/screens/asset_capture_page.dart

// MODIFIED: This function now navigates to the PdfViewerScreen with an asset path
// In lib/screens/asset_capture_page.dart

  Future<void> _openVendorDataUrl() async {
    // Direct path to your image asset
    final String imageAssetPath = 'assets/images/consent_form_image.jpg'; // <--- USE YOUR IMAGE PATH HERE

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewerScreen(
          title: 'Consent Form', // Title for the image viewer screen's AppBar
          imageAssetPath: imageAssetPath, // Pass the image asset path
        ),
      ),
    );
  }

  Future<void> _showDialog(String title, String message) async {
    if (!mounted) return;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.brown, size: 20),
                    Text('Back', style: TextStyle(fontSize: 18, color: Colors.brown)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Capture Assets for: ${widget.outletName}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 30),
            // Location Section
            Text(
              'Location Details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isEditable ? Colors.brown : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: _isEditable ? Colors.white : Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.brown, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _capturedLocation ?? 'Location not captured',
                    style: TextStyle(
                      fontSize: 16,
                      color: _capturedLocation != null ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  styledButton(
                    text: _isLoadingLocation ? 'Getting Location...' : 'Get Location',
                    onPressed: _isLoadingLocation || !_isEditable ? null : _getCurrentLocation,
                    buttonColor: _isEditable ? Colors.brown : Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Photos Section
            Text(
              'Photo Capture:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isEditable ? Colors.brown : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                PhotoCaptureGridItem(
                  label: 'Outlet Exteriors Photo',
                  pickedFilePath: _resolvedImagePaths['outlet_exteriors_photo'],
                  onTap: () => _pickImage('outlet_exteriors_photo'),
                  isEditable: _isEditable,
                ),
                PhotoCaptureGridItem(
                  label: 'Asset Pics',
                  pickedFilePath: _resolvedImagePaths['asset_pics'],
                  onTap: () => _pickImage('asset_pics'),
                  isEditable: _isEditable,
                ),
                PhotoCaptureGridItem(
                  label: 'Outlet Owner ID\'s Pics',
                  pickedFilePath: _resolvedImagePaths['outlet_owner_ids_pics'],
                  onTap: () => _pickImage('outlet_owner_ids_pics'),
                  isEditable: _isEditable,
                ),
                PhotoCaptureGridItem(
                  label: 'Outlet Owner Pic',
                  pickedFilePath: _resolvedImagePaths['outlet_owner_pic'],
                  onTap: () => _pickImage('outlet_owner_pic'),
                  isEditable: _isEditable,
                ),
                PhotoCaptureGridItem(
                  label: 'Serial No. Pic',
                  pickedFilePath: _resolvedImagePaths['serial_no_pic'],
                  onTap: () => _pickImage('serial_no_pic'),
                  isEditable: _isEditable,
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: styledButton(
                text: _isEditable ? 'initiate aggrement' : 'Continue',
                onPressed: _isEditable ? _submitShopDetails : _openVendorDataUrl,
                buttonColor: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}