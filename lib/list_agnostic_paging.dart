import 'package:flutter/material.dart';

enum LoadState { loading, loaded, error, empty }

class AgnosticInfinitePaging<T> extends StatefulWidget {
  final Future<List<T>> Function(int page) fetchData;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final ScrollType scrollType;
  final SliverGridDelegate? gridDelegate; // Only used for GridView

  AgnosticInfinitePaging({
    required this.fetchData,
    required this.itemBuilder,
    this.scrollType = ScrollType.listView,
    this.gridDelegate, // Optional gridDelegate for GridView
  });

  @override
  _AgnosticInfinitePagingState<T> createState() => _AgnosticInfinitePagingState<T>();
}

class _AgnosticInfinitePagingState<T> extends State<AgnosticInfinitePaging<T>> {
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
    Widget scrollView;
    if (widget.scrollType == ScrollType.listView) {
      scrollView = ListView.builder(
        controller: _scrollController,
        itemCount: _data.length + 1,
        itemBuilder: (context, index) {
          if (index < _data.length) {
            return widget.itemBuilder(context, _data[index]);
          } else {
            if (_loadState == LoadState.loading) {
              return CircularProgressIndicator();
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
    } else if (widget.scrollType == ScrollType.gridView) {
      scrollView = GridView.builder(
        controller: _scrollController,
        gridDelegate: widget.gridDelegate!,
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
    } else {
      throw ArgumentError("Invalid ScrollType");
    }

    return scrollView;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

enum ScrollType { listView, gridView }
