import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stream_app_full_stack/screens/chat.dart';
import 'package:stream_app_full_stack/screens/drawer.dart';
import 'package:stream_app_full_stack/screens/fcmNof.dart';
import 'package:stream_app_full_stack/screens/imageUpRe.dart';

class Homescreen extends StatelessWidget {
  final String userid;
  final String username;
   Homescreen({super.key, required this.userid, required this.username });
  final List<Map<String, dynamic>> items = const [
    {'title': 'Phone', 'icon': Icons.phone},
    {'title': 'Email', 'icon': Icons.email},
    {'title': 'Location', 'icon': Icons.location_on},
    {'title': 'Settings', 'icon': Icons.settings},
    {'title': 'Help', 'icon': Icons.help},
    {'title': 'Message', 'icon': Icons.message},
    {'title': 'Contacts', 'icon': Icons.contacts},
    {'title': 'Camera', 'icon': Icons.camera},
  ];
  final String apiUrl = 'http://localhost:3600/api/details/Pakistani';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(userid),
                SizedBox(
                  width: 40,
                ),
                Text('Hi icon'),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(username),
          Text('down'),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(items[index]['icon']),
                  title: Text(items[index]['title']),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You tapped on ${items[index]['title']}')));
                  },
                );
              },
            ),
          ),
          ElevatedButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FcmNotification()),);
          }, child: Text('Next Screen'))

        ],
      ),
    );
  }
}
