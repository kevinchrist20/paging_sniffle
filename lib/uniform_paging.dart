import 'package:flutter/material.dart';

class LazyPagingColumn extends StatefulWidget {
  @override
  _LazyPagingColumnState createState() => _LazyPagingColumnState();
}

class _LazyPagingColumnState extends State<LazyPagingColumn> {
  List<String> data = [];
  int currentPage = 1;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Simulate loading data from an API or database.
  void loadData() {
    // You can replace this with your data loading logic.
    for (int i = 0; i < itemsPerPage; i++) {
      data.add('Item ${data.length + 1}');
    }
  }

  // Load more data when the user reaches the end of the list.
  void loadMoreData() {
    // setState(() {
      currentPage++;
    // });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lazy Paging Column'),
      ),
      body: ListView.builder(
        itemCount: data.length + 1, // +1 for the loading indicator
        itemBuilder: (context, index) {
          if (index < data.length) {
            return ListTile(
              title: Text(data[index]),
            );
          } else {
            // Display a loading indicator at the end of the list.
            if (data.length < currentPage * itemsPerPage) {
              // If there is no more data to load, you can display a message.
              return Center(
                child: Text('No more items to load.'),
              );
            } else {
              // Load more data when the user scrolls to the end.
              loadMoreData();
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }
}
