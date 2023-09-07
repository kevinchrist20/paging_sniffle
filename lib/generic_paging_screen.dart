import 'package:flutter/material.dart';

import 'generic_paging.dart';

class GenericPagingScreen extends StatefulWidget {
  const GenericPagingScreen({super.key});

  @override
  State<GenericPagingScreen> createState() => _GenericPagingScreenState();
}

class _GenericPagingScreenState extends State<GenericPagingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Infinite Paging Example')),
      body: InfinitePaging<int>(
        fetchData: (page) async {
          await Future.delayed(Duration(seconds: 2)); // Simulate API call delay
          return List.generate(20, (index) => (page - 1) * 20 + index + 1);
        },
        itemBuilder: (context, item) => ListTile(
          title: Text(
            item.toString(),
          ),
        ),
      ),
    );
  }
}
