// import 'package:flutter/material.dart';
// // import 'package:ferrero_app/utils/constants.dart'; // Uncomment if you use AppAssets
//
// class CustomTextFormField extends StatelessWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final String hintText;
//   final FocusNode focusNode;
//   final ValueNotifier<bool> isFocusedNotifier;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;
//   final bool obscureText;
//
//   const CustomTextFormField({
//     super.key,
//     required this.controller,
//     required this.labelText,
//     required this.hintText,
//     required this.focusNode,
//     required this.isFocusedNotifier,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//     this.obscureText = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text.rich(
//           TextSpan(
//             text: labelText,
//             style: const TextStyle(fontSize: 18, color: Colors.brown),
//             children: const [TextSpan(text: ' *', style: TextStyle(fontSize: 18, color: Colors.red))],
//           ),
//         ),
//         const SizedBox(height: 8),
//         ValueListenableBuilder<bool>(
//           valueListenable: isFocusedNotifier,
//           builder: (context, isFocused, child) {
//             return Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 image: const DecorationImage(
//                   image: AssetImage('assets/rect1.png'), // Use AppAssets.rect1 if you uncommented the import
//                   fit: BoxFit.cover,
//                   repeat: ImageRepeat.repeat,
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isFocused ? Colors.amber.withOpacity(0.5) : Colors.brown.withOpacity(0.2),
//                     blurRadius: isFocused ? 8 : 3,
//                     spreadRadius: isFocused ? 2 : 0,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: TextFormField(
//                 controller: controller,
//                 focusNode: focusNode,
//                 keyboardType: keyboardType,
//                 obscureText: obscureText,
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//                 decoration: InputDecoration(
//                   hintText: hintText,
//                   hintStyle: const TextStyle(color: Colors.white70),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//                 ),
//                 validator: validator,
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
// widgets/custom_text_form_field.dart
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final FocusNode focusNode;
  final ValueNotifier<bool> isFocusedNotifier;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly; // <--- ADD THIS PARAMETER

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.focusNode,
    required this.isFocusedNotifier,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.readOnly = false, // <--- SET DEFAULT VALUE TO false
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isFocusedNotifier,
      builder: (context, isFocused, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: labelText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isFocused ? Colors.brown[700] : Colors.brown, // Adjust color as needed
                ),
                children: const [TextSpan(text: '*', style: TextStyle(fontSize: 18, color: Colors.red))],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: isFocused ? Colors.brown[700]! : Colors.transparent, // Highlight on focus
                  width: 2.0,
                ),
              ),
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                readOnly: readOnly, // <--- PASS readOnly TO TextFormField
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  border: InputBorder.none,
                  // fillColor: readOnly ? Colors.grey[200] : Colors.white, // Optional: change background when readOnly
                  // filled: true, // Required for fillColor
                ),
                validator: validator,
                keyboardType: keyboardType,
                style: TextStyle(
                  color: readOnly ? Colors.grey[700] : Colors.black, // Optional: change text color when readOnly
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}