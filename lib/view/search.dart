import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Single Chat',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Color(0x54FFFFFF),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.black54),
                    decoration: InputDecoration(
                      hintText: 'Search userName...',
                        border: InputBorder.none
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.search), onPressed: (){})
              ],
            ),
          ),
        ],
      ),
    );
  }
}
