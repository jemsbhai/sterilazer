import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sterilazer/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommandBuilder extends StatefulWidget {
  @override
  _CommandBuilderState createState() => _CommandBuilderState();
}

class _CommandBuilderState extends State<CommandBuilder> {
  String name;
  String description;
  String duration;
  final Firestore _firestore = Firestore.instance;


  Future<void> newCommand() async{
    await _firestore.collection('commands').document(name).setData({
      'name': name,
      'description' : description,
      'duration' : duration
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body:  Padding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Command Builder',style: TextStyle(
              fontSize: 44
            ),),
            Divider(thickness: 3,),
            TextField(
                onChanged: (value) => name = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    ),
                    labelText: 'Command Name',
                    hintText: 'Name',
                    fillColor: Colors.deepPurpleAccent
                )
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
                onChanged: (value) => description = value,
                maxLines: null,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    ),
                    labelText: 'Command Description',
                    hintText: 'Description',
                    fillColor: Colors.deepPurpleAccent
                )
            ),SizedBox(
              height: 15,
            ),
            TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => duration = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    ),
                    labelText: 'Duration',
                    hintText: 'Duration in Seconds',
                    fillColor: Colors.deepPurpleAccent
                )
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.red,
                    child: Text('Cancel'),
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) => Home()
                      ));
                    },
                  ),
                  SizedBox(width: 6,),
                  RaisedButton(
                    child: Text('Save'),
                    color: Colors.green,
                    onPressed: () async {
                      newCommand();
                      final http.Response response = await http.post(
                        'https://enxcnyl9a2gp9.x.pipedream.net',
                        body: jsonEncode(<String, String>{
                          'name': name,
                          'duration': duration,
                          'intensity': '50'
                        }),
                      );
                      print(response.body.toString());
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) => Home()
                      ));
                    },
                  ),
                ],
              ),
            )

          ],
        ),
        padding: EdgeInsets.all(16),
      )
    );
  }
}
