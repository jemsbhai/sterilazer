import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sterilazer/classes/countdown.dart';


class Home extends StatefulWidget {
  final bool queueState;

  const Home({Key key, this.queueState}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  String time;
  AnimationController _controller;
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
        return Container(
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
        );
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    setState(() {
                      on = true;
                      _controller = AnimationController(
                          vsync: this,
                          duration: Duration(
                              seconds: int.parse(time)
                          )// gameData.levelClock is a user entered number elsewhere in the applciation
                      );
                      _controller.forward();
                    });
                  },
                ),
                FlatButton(
                  color: Colors.red,
                  child: Text('Stop'),
                  onPressed: (){
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

gi
              ],
            )


          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add,color: Colors.blueAccent,),
        onPressed: (){

        },

      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        shape: CircularNotchedRectangle(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.wb_sunny),
                onPressed: (){},
              ),
              IconButton(
                icon: Icon(Icons.wb_sunny),
                onPressed: (){},
              ),
            ],
          ),
        )
      ),
    );
  }
}
