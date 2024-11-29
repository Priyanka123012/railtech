// import 'package:flutter/material.dart';

// class CustomDropdown
//     extends StatefulWidget {
//   final List<String>
//       items;
//   final String
//       hint;
//   final ValueChanged<String?>
//       onChanged;

//   CustomDropdown({
//     required this.items,
//     required this.hint,
//     required this.onChanged,
//   });

//   @override
//   _CustomDropdownState createState() =>
//       _CustomDropdownState();
// }

// class _CustomDropdownState
//     extends State<CustomDropdown> {
//   bool
//       _isDropdownOpen =
//       false;
//   String?
//       _selectedItem;

//   void
//       _toggleDropdown() {
//     setState(() {
//       _isDropdownOpen = !_isDropdownOpen;
//     });
//   }

//   void _selectItem(
//       String item) {
//     setState(() {
//       _selectedItem = item;
//       _isDropdownOpen = false;
//     });
//     widget.onChanged(item);
//   }

//   @override
//   Widget
//       build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: _toggleDropdown,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _selectedItem ?? widget.hint,
//                   style: TextStyle(color: _selectedItem == null ? Colors.grey : Colors.black),
//                 ),
//                 Icon(
//                   _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (_isDropdownOpen)
//           Container(
//             margin: EdgeInsets.only(top: 8),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.white,
//             ),
//             child: ListView(
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               children: widget.items.map((item) {
//                 return GestureDetector(
//                   onTap: () => _selectItem(item),
//                   child: SingleChildScrollView(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       child: Text(item),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//       ],
//     );
//   }
// }
