//
//
// import 'package:flutter/material.dart';
// import 'dart:io'; // Re-import dart:io for File
//
// import 'package:image_picker/image_picker.dart'; // Import XFile
//
// class PhotoCaptureGridItem extends StatelessWidget {
//   final String imageType;
//   final String label;
//   // Reverted back to XFile? pickedFile
//   final XFile? pickedFile;
//   final VoidCallback onTap;
//
//   const PhotoCaptureGridItem({
//     super.key,
//     required this.imageType,
//     required this.label,
//     this.pickedFile, // Changed back to pickedFile
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFFF0E4D4), // Assuming AppColors.lightOrange
//           borderRadius: BorderRadius.circular(15.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // MODIFIED: Use Image.file for XFile
//             pickedFile != null
//                 ? Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10.0),
//                   // Use Image.file for XFile
//                   child: Image.file(
//                     File(pickedFile!.path),
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       // Fallback if image fails to load
//                       return const Center(
//                         child: Icon(Icons.broken_image, size: 50, color: Colors.red),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             )
//                 : const Icon(
//               Icons.camera_alt,
//               size: 50,
//               color: Color(0xFF5D4037), // Assuming AppColors.darkBrown
//             ),
//             const SizedBox(height: 10),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF5D4037), // Assuming AppColors.darkBrown
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PhotoCaptureGridItem extends StatelessWidget {
  final String label;
  final String? pickedFilePath; // Renamed to clarify it's a path
  final VoidCallback? onTap; // Made nullable for read-only state
  final double width;
  final double height;
  final bool isEditable; // New parameter to control editability

  const PhotoCaptureGridItem({
    super.key,
    required this.label,
    this.pickedFilePath,
    this.onTap,
    this.width = 100,
    this.height = 100,
    this.isEditable = true, // Default to true for new shops
  });

  @override
  Widget build(BuildContext context) {
    // Determine the image to display (either asset or file)
    Widget imageWidget;
    if (pickedFilePath != null) {
      if (pickedFilePath!.startsWith('assets/')) {
        imageWidget = Image.asset(pickedFilePath!, fit: BoxFit.cover);
      } else if (File(pickedFilePath!).existsSync()) {
        imageWidget = Image.file(File(pickedFilePath!), fit: BoxFit.cover);
      } else {
        // Fallback if path is not asset and not a valid file (e.g., broken link)
        imageWidget = const Icon(Icons.broken_image, size: 40, color: Colors.grey);
      }
    } else {
      imageWidget = const Icon(Icons.camera_alt, size: 40, color: Colors.grey);
    }

    return GestureDetector(
      // Only allow tap if it's editable
      onTap: isEditable ? onTap : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.brown, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: pickedFilePath != null
                    ? imageWidget
                    : const Center(child: Icon(Icons.camera_alt, size: 40, color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.brown),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}