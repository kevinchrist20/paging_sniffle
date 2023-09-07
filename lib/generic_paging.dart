import 'package:flutter/material.dart';

enum LoadState { loading, loaded, error, empty }

class InfinitePaging<T> extends StatefulWidget {
  final Future<List<T>> Function(int page) fetchData;
  final Widget Function(BuildContext context, T item) itemBuilder;

  InfinitePaging({required this.fetchData, required this.itemBuilder});

  @override
  _InfinitePagingState<T> createState() => _InfinitePagingState<T>();
}

class _InfinitePagingState<T> extends State<InfinitePaging<T>> {
  final ScrollController _scrollController = ScrollController();
  List<T> _data = [];
  LoadState _loadState = LoadState.loading;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_loadState != LoadState.loading) {
        _fetchData();
      }
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _loadState = LoadState.loading;
    });

    try {
      final newData = await widget.fetchData(_currentPage);
      if (newData.isEmpty) {
        setState(() {
          _loadState = LoadState.empty;
        });
      } else {
        setState(() {
          _data.addAll(newData);
          _currentPage++;
          _loadState = LoadState.loaded;
        });
      }
    } catch (e) {
      setState(() {
        _loadState = LoadState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _data.length + 1,
      itemBuilder: (context, index) {
        if (index < _data.length) {
          return widget.itemBuilder(context, _data[index]);
        } else {
          if (_loadState == LoadState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (_loadState == LoadState.empty) {
            return Center(child: Text('No more items to load.'));
          } else if (_loadState == LoadState.error) {
            return Center(child: Text('Error loading data.'));
          } else {
            return Container(); // Return an empty container as a placeholder.
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
