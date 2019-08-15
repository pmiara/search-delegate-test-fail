import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Entity {
  final String value;

  Entity.fromJson(Map<String, dynamic> json) : value = json['value'];
}

class MySearchDelegate extends SearchDelegate {
  final MySearchEngine searchEngine;

  MySearchDelegate({@required this.searchEngine});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Entity>>(
      future: searchEngine.search(query),
      builder: (BuildContext context, AsyncSnapshot<List<Entity>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final entities = snapshot.data;
          // Close() is inside Future.delayed, because we need to do both:
          // 1. call close() which returns results and finishes searching,
          // 2. return some Widget.
          Future.delayed(Duration.zero, () async {
            close(context, entities);
          });
          return ListView.builder(
            itemCount: entities.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(entities[index].value),
              onTap: () => close(context, entities[index]),
            ),
          );
        } else {
          return Column();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Entity>>(
      future: searchEngine.search(query),
      builder: (BuildContext context, AsyncSnapshot<List<Entity>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final entities = snapshot.data;
          return ListView.builder(
            itemCount: entities.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(entities[index].value),
              onTap: () {
                query = entities[index].value;
                showResults(context);
              },
            ),
          );
        } else {
          return Column();
        }
      },
    );
  }
}

class MySearchEngine {
  Future<List<Entity>> search(String query) async {
    final jsonEntities =
        await rootBundle.loadString('test_resources/entities.json');
    final entities = jsonDecode(jsonEntities)
        .map<Entity>((json) => Entity.fromJson(json))
        .toList();
    return entities;
    // Another bug: return entities.where((e) => e.value.contains(query)).toList();
  }
}

class TestHomePage extends StatelessWidget {
  final MySearchDelegate delegate;

  const TestHomePage({@required this.delegate});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: Center(
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  showSearch(
                    context: context,
                    delegate: delegate,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Run to see what tests should "see"
void main() => runApp(
      TestHomePage(
        delegate: MySearchDelegate(
          searchEngine: MySearchEngine(),
        ),
      ),
    );
