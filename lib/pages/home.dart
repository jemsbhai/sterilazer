
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sterilazer/classes/countdown.dart';
import 'package:sterilazer/pages/command.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final bool queueState;

  const Home({Key key, this.queueState}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  String time;
  AnimationController _controller;
  final Firestore _firestore = Firestore.instance;
  bool on = false;
  final TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget checkOn(){
      if (on){
        return Column(
          children: <Widget>[
            Text('Steri-Laser is On!',style: TextStyle(
              fontSize: 22
            ),),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              height: 300,
              child: Align(alignment: Alignment.center,
                child: Container(
                  height: 280,
                  width: 280,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Countdown(
                          animation: StepTween(
                            begin: int.parse(time), // THIS IS A USER ENTERED NUMBER
                            end: 0,
                          ).animate(_controller),
                        ),
                      ],
                    ),
                  ),
                ),),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent
              ),
            )
          ],
        )
          ;
  }
      else{
        return TextField(
            controller: _textEditingController,
            keyboardType: TextInputType.number,
            onChanged: (value) => time = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3))
                ),
                hintText: 'Time in Seconds',
                fillColor: Colors.deepPurpleAccent
            )
        );
  }
      }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => new Column(children: <Widget>[
      Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent)
          ),
          child: ListTile(
              onTap: ()async {
                var response = await http.get('https://us-central1-aiot-fit-xlab.cloudfunctions.net/sterilazeron');
                print(response.body);
                setState(() {
                  time = doc['duration'];
                  on = true;
                  _controller = AnimationController(
                      vsync: this,
                      duration: Duration(
                          seconds: int.parse(time)
                      )
                  );
                  _controller.forward();
                });
              },
              title: Text(doc["name"]), leading:
          Text(doc['duration'] + '\nseconds',textAlign: TextAlign.center,),
              subtitle: Text(doc["description"].toString()))
      ) ,
      SizedBox(
        height: 5,
      )
    ],)
    )
        .toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.all(16),
          child: Image(
            image: AssetImage(
                'assets/images/sterilaser.png'
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(

          children: <Widget>[
            checkOn(),
            SizedBox(
              height: 5,
            ),
            Divider(thickness: 3,),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text('Start'),
                  color: Colors.green,
                  onPressed: (){
                    setState(() async{
                      var response = await http.get('https://us-central1-aiot-fit-xlab.cloudfunctions.net/sterilazeron');
                      print(response.body);
                      on = true;
                      _controller = AnimationController(
                          vsync: this,
                          duration: Duration(
                              seconds: int.parse(time)
                          )
                      );
                      _controller.forward();
                    });
                  },
                ),
                FlatButton(
                  color: Colors.red,
                  child: Text('Stop'),
                  onPressed: () async{
                    var response = await http.get('https://us-central1-aiot-fit-xlab.cloudfunctions.net/sterilazeroff');
                    print(response.body);
                    setState(() {
                      on = false;
                    });
                  },
                ),
                FlatButton(
                  color: Colors.grey,
                  child: Text('Clear'),
                  onPressed: (){
                  _textEditingController.clear();
                  },
                ),



              ],
            ),

            SizedBox(
              height: 15,
            ),
            Divider(thickness: 3,),
            Text('Your Commands',style: TextStyle(
              fontSize: 22
            ),),
            SizedBox(
              height: 5,
            ),
//            FlatButton(
//              child: Text('h'),
//              onPressed: () async {
//                QuerySnapshot querySnapshot = await Firestore.instance.collection("commands").getDocuments();
//                print(querySnapshot.documents[0].data['name']);
//              },
//            ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child:  FutureBuilder(
                  future: Firestore.instance.collection('commands').getDocuments(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {

                    if (snapshot.hasData) {
                      if (snapshot.data!=null) {

                        return new ListView(
                            shrinkWrap: true,children: getExpenseItems(snapshot));
                      } else {
                        return new CircularProgressIndicator();
                      }
                    }
                    return Container();
                  }
              )
          ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add,color: Colors.blueAccent,),
        onPressed: (){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CommandBuilder()
            )
          );
        },

      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        shape: CircularNotchedRectangle(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 30,
              )
            ],
          ),
        )
      ),
    );
  }
}
