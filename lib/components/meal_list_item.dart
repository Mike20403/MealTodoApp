import 'package:flutter/material.dart';
import 'package:flutterproject/modals/meal.dart';

class MealListItem extends StatefulWidget {
  (Meal,int) meal;
  Function(double price,int amount) onPriceAmountChanged;
  MealListItem(this.meal, {required this.onRemove, required this.onPriceAmountChanged});
  final void Function() onRemove;

  @override
  State<MealListItem> createState() => _MealListItemState();
}

class _MealListItemState extends State<MealListItem> {
  int amount = 0;


  @override
  Widget build(BuildContext context) {
    amount = widget.meal.$2;
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.white,
      child: ListTile(
          onTap: () {},
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 20),
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (
                        ) {
                      widget.onRemove();
                    },
                  )),
              Image.network(
                widget.meal!.$1.urlImage,
                width: 80,
                height: 50,
                fit: BoxFit.fill,
              ),
            ],
          ) // Replace with your image source
          ,
          title: Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0,
            children: [ Text(widget.meal!.$1.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16*height*width*0.0000005)),],


            // margin: EdgeInsets.only(left: 20),
          ),
          trailing: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Ink(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 9, 173,
                            170), // Set the desired background color
                        shape:
                            BoxShape.rectangle, // Shape as a rectangle (square)
                      ),
                      child: InkWell(
                        onTap: () {
                          if (amount> 0) {
                            setState(() {
                             amount--;
                             this.widget.onPriceAmountChanged(this.widget.meal.$1.price,amount);
                            });
                          }
                        },
                        splashColor: Colors.white,
                        child: const SizedBox(
                          width: 36, // Adjust the width as needed
                          height: 36, // Adjust the height as needed
                          child: Icon(Icons.remove,
                              color: Colors.white), // Set the icon color
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(amount.toString()),
                    ),
                    Ink(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 9, 173,
                            170), // Set the desired background color
                        shape:
                            BoxShape.rectangle, // Shape as a rectangle (square)
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (amount < this.widget.meal!.$1.amount){
                              amount++;
                              this.widget.onPriceAmountChanged(this.widget.meal.$1.price,amount);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                                content: Align(child:Text('Amount exceeded!!!',style: TextStyle(color: Colors.white),),alignment: Alignment.center,),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.redAccent,
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height - 100,
                                    right: 20,
                                    left: 20),
                              ));
                            }

                          });
                        },
                        splashColor: Colors.white,
                        child: const SizedBox(
                          width: 36, // Adjust the width as needed
                          height: 36, // Adjust the height as needed
                          child: Icon(Icons.add,
                              color: Colors.white), // Set the icon color
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  child: Text('\$' + this.widget.meal!.$1.price.toString(),
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(
                      '\$${(widget.meal!.$1.price * widget.meal!.$2).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        overflow: TextOverflow.ellipsis,
                      )),
                ),
              ])),
    );
  }
}
