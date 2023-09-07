import 'package:flutter/material.dart';
import 'package:uniform_paging/list_agnostic_paging.dart';

class ListAgnosticPaging extends StatefulWidget {
  const ListAgnosticPaging({super.key});

  @override
  State<ListAgnosticPaging> createState() => _ListAgnosticPagingState();
}

class _ListAgnosticPagingState extends State<ListAgnosticPaging> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Infinite Paging Example')),
      body: AgnosticInfinitePaging<int>(
        fetchData: (page) async {
          await Future.delayed(Duration(seconds: 2)); // Simulate API call delay
          return List.generate(10, (index) => (page - 1) * 10 + index + 1);
        },
        itemBuilder: (context, item) => ListTile(title: Text(item.toString())),
        scrollType: ScrollType.gridView, // Use GridView
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Specify the number of columns
        ),
      ),
    );
  }
}
