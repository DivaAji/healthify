// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:healthify/screens/program/detail_program_screen.dart';
// import 'package:healthify/widgets/program_indicator.dart';

// class CustomCarouselSlider extends StatefulWidget {
//   final List<String> imageUrls;
//   final List<String> chosenPrograms;
//   final List<String> descriptions;

//   CustomCarouselSlider({
//     required this.imageUrls,
//     required this.chosenPrograms,
//     required this.descriptions,
//   });

//   @override
//   _CustomCarouselSliderState createState() => _CustomCarouselSliderState();
// }

// class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
//   late CarouselController _carouselController;
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _carouselController = CarouselController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return CarouselSlider(
//       options: CarouselOptions(
//         height: screenHeight * 0.28,
//         autoPlay: false,
//         enlargeCenterPage: true,
//         viewportFraction: 1.0,
//         enableInfiniteScroll: false,
//         onPageChanged: (index, reason) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//       items: widget.imageUrls.map((url) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: GestureDetector(
//             onTap: () {
//               // Navigasi ke halaman DetailProgram
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MyDetailProgram(
//                     programName: widget.chosenPrograms[_currentIndex],
//                     programImage: url,
//                     programDescription: widget.descriptions[_currentIndex],
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               width: screenWidth,
//               margin: EdgeInsets.symmetric(horizontal: 5.0),
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.asset(
//                       'assets/images/$url',
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                       height: screenHeight * 0.28,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     left: 0,
//                     right: 0,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: const Color.fromRGBO(0, 139, 144, 1),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           margin: EdgeInsets.only(left: 20),
//                           padding: EdgeInsets.symmetric(
//                             vertical: 2,
//                             horizontal: 10,
//                           ),
//                           height: 25,
//                           child: Text(
//                             '${_currentIndex + 1} / ${widget.imageUrls.length}',
//                             style: TextStyle(
//                               color: const Color.fromRGBO(33, 50, 75, 1),
//                               fontFamily: 'Galatea',
//                               fontSize: 14,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         ProgramIndicator(
//                           name: widget.chosenPrograms[_currentIndex],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }