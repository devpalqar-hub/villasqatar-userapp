// import 'package:flutter/material.dart';
// import 'package:villas_qatar/modules/PlansandFeatures/model/featured_property_model.dart';
// import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

// class PropertyComparisonScreen extends StatelessWidget {
//   final Property currentProperty;
//  final List<Property> compareProperties;

//   const PropertyComparisonScreen({
//     super.key,
//     required this.currentProperty,
//     required this.compareProperties,
//   });

//   @override
//   Widget build(BuildContext context) {
     
//     final rows = [

//   ComparisonRow(
//     "Property Type",
//     (p) => p.type.title,
//   ),

//   ComparisonRow(
//     "Price",
//     (p) => "QAR ${p.price.toStringAsFixed(0)}",
//   ),

//   ComparisonRow(
//     "Bedrooms",
//     (p) => "${p.bedrooms}",
//   ),

//   ComparisonRow(
//     "Bathrooms",
//     (p) => "${p.bathrooms}",
//   ),

//   ComparisonRow(
//     "Area",
//     (p) => "${p.area} sqm",
//   ),

//   ComparisonRow(
//     "Furnishing",
//     (p) => p.furnishing.title,
//   ),

//   ComparisonRow(
//     "Parking",
//     (p) => p.parkingSpaces > 0 ? "Yes" : "No",
//   ),

//   ComparisonRow(
//     "Living Rooms",
//     (p) => "${p.livingRooms}",
//   ),

//   ComparisonRow(
//     "Floor",
//     (p) => "${p.floorNumber}",
//   ),

//   ComparisonRow(
//     "Status",
//     (p) => p.status,
//   ),
// ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Compare Properties"),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Column(
//           children: [

//             /// Header
//             Row(
//               children: [

//                 const SizedBox(
//                   width: 140,
//                 ),

//               _HeaderCard(currentProperty),

// ...compareProperties.map(
//   (property) => _HeaderCard(property),
// ),
//               ],
//             ),

//             const Divider(),

//             ...rows.map(
//               (row) => _ComparisonRowWidget(
//                 row: row,
//                properties: [
//   currentProperty,
//   ...compareProperties,
// ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HeaderCard extends StatelessWidget {
//   final Property property;

//   const _HeaderCard(this.property);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 180,
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         children: [

//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.network(
//               property.sortedPhotos.isNotEmpty
//                   ? property.sortedPhotos.first.url
//                   : "",
//               height: 120,
//               width: 180,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) =>
//                   const Icon(Icons.image, size: 80),
//             ),
//           ),

//           const SizedBox(height: 10),

//           Text(
//             property.propertyName,
//             textAlign: TextAlign.center,
//             maxLines: 2,
//           ),

//           const SizedBox(height: 5),

//           Text(
//             "QAR ${property.price.toStringAsFixed(0)}",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// class ComparisonRow {
//   final String title;
//   final String Function(Property) value;

//   ComparisonRow(this.title, this.value);
// }


// class _ComparisonRowWidget extends StatelessWidget {
//   final ComparisonRow row;
//   final List<Property> properties;

//   const _ComparisonRowWidget({
//     super.key,
//     required this.row,
//     required this.properties,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Colors.grey.shade300,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 140,
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               row.title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),

//           ...properties.map(
//             (property) => Container(
//               width: 180,
//               padding: const EdgeInsets.all(12),
//               child: Text(row.value(property)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }