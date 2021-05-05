import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = "https://randomuser.me/api/?results=50";
  List usersData;
  bool isLoading = true;

  Future<String> getData() async {
    var responce = await http.get(Uri.encodeFull(url));
    //this time body is also in form of list (like bodyData->List(results) && result[0]->List)
    List convertToJSON = json.decode(responce.body)['results'];
    setState(() {
      usersData = convertToJSON;
      isLoading = false;
    });
    // print(usersData);
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Users via randomuser.me"),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: usersData == null ? 0 : usersData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blueGrey[100],
                                backgroundImage: NetworkImage(
                                    usersData[index]['picture']['thumbnail']),
                              ),
                            ),
                            Expanded(
                              child: new Container(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: new Text(
                                        usersData[index]['name']['first'] +
                                            " " +
                                            usersData[index]['name']['last'],
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: new Text(
                                        "Age: ${usersData[index]['dob']['age']}",
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: <Widget>[
                                        new Icon(
                                          Icons.person,
                                          color: Colors.blueAccent,
                                        ),
                                        SizedBox(width: 5.0),
                                        new Text(usersData[index]['gender']),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: <Widget>[
                                        new Icon(
                                          Icons.phone,
                                          color: Colors.blueAccent,
                                        ),
                                        SizedBox(width: 5.0),
                                        new Text(usersData[index]['phone']),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: <Widget>[
                                        new Icon(
                                          Icons.email,
                                          color: Colors.blueAccent,
                                        ),
                                        SizedBox(width: 5.0),
                                        new Text(usersData[index]['email']),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )),
      ),
    );
  }
}
