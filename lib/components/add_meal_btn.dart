import 'package:flutter/material.dart';
import 'package:flutterproject/main.dart';

class AddMealBtn extends StatefulWidget {
  final void Function() onClickAdd;

  AddMealBtn({required this.onClickAdd, required Key key}):super(key:key);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddMealState();
  }
}
class AddMealState extends State<AddMealBtn>{


  @override
  Widget build(BuildContext context) {
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

// Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double height1 = height - padding.top - padding.bottom;

// Height (without status bar)
    double height2 = height - padding.top;

// Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight;

    return InkWell(
      onTap: () => null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: new Column(
                  children: <Widget>[
                    ClipRect(
                      child: Material(
                        // button color
                        child: InkWell(
                          //splashColor: Colors.red, // inkwell color
                          child: Container(
                            color: Colors.grey,
                            height: 0.2 * height,
                            width: 0.14 * width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255,209,208,209),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 80,
                              ),
                              onPressed: (){
                                  this.widget.onClickAdd();
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: new Column(
                  children: <Widget>[
                    new Text(
                      "",
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

