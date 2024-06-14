// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:event_master_web/data_layer/services/database.dart';
// import 'package:flutter/material.dart';

// class CategoryDetailScreen extends StatelessWidget {
//   final String categoryId;
//   final DatabaseMethods databaseMethods = DatabaseMethods();

//   CategoryDetailScreen({Key? key, required this.categoryId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Icon(Icons.close),
//         ),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: databaseMethods.getVendorDetail(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error loading category details',
//                 style: TextStyle(color: Colors.red),
//               ),
//             );
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(
//               child: Text(
//                 'No Category Found',
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           }

//           var categoryData = snapshot.data!.data() as Map<String, dynamic>;

//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     categoryData['name'] ?? 'No Name',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     categoryData['description'] ?? 'No Description',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 16),
//                   categoryData['imagePath'] != null
//                       ? Image.network(categoryData['imagePath'])
//                       : Text('No Image'),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
