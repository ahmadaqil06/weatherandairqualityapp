// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:weatherandairqualityapp/services/database_helper.dart';

// class HistoryPage extends StatefulWidget {
//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   @override
//   void initState() {
//     super.initState();
//     final mongoService = Provider.of<MongoService>(context, listen: false);
//     mongoService.connect();
//   }

//   @override
//   void dispose() {
//     final mongoService = Provider.of<MongoService>(context, listen: false);
//     mongoService.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mongoService = Provider.of<MongoService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('History'),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: mongoService.getHistory(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No history found.'));
//           } else {
//             final history = snapshot.data!;
//             return ListView.builder(
//               itemCount: history.length,
//               itemBuilder: (context, index) {
//                 final item = history[index];
//                 return ListTile(
//                   title: Text(item['name'] ?? 'No name'),
//                   subtitle: Text('Latitude: ${item['latitude']}, Longitude: ${item['longitude']}'),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
