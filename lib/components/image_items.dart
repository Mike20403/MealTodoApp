import 'package:flutter/material.dart';
import 'package:flutterproject/modals/meal.dart';

class ImageItem extends StatelessWidget {
  final num id;
  final String name;
  final String imgURL;
  final double price;
  final int amount;
  final void Function() onAddtoShoppingCart;
  final void Function() onDelete;
  final void Function(num id, String name,String url,int amount,double price) onEdit;
  // final GlobalKey _inkWellKey = GlobalKey();




   ImageItem(this.id,this.name, this.imgURL,this.amount,this.price, {required this.onEdit,required this.onAddtoShoppingCart,required this.onDelete,required Key key}): super(key: key);

  void selectCategory() {

  }
  showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Action"),
          content: Text("Are you sure you want to perform this action?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                // Perform the action
                // ...
                this.onDelete();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  void showEditMealDialog(BuildContext context) async {

    final _imageUrlController = TextEditingController(text: imgURL);
    final _nameController = TextEditingController(text: name);
    final _amountController = TextEditingController(text: amount.toString());
    final _priceController = TextEditingController(text: price.toString());

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Product'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _imageUrlController,
                    onChanged: (value) {
                      setState(
                              () {}); // Trigger a rebuild to update the image preview
                    },
                    decoration: InputDecoration(labelText: 'Image URL'),
                  ),
                  SizedBox(height: 10),
                  _imageUrlController.text.isNotEmpty
                      ? Container(
                    child: Image.network(_imageUrlController.text),
                    width: 400,
                    height: 400,
                  )
                      : Container(),
                  SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {

                      this.onEdit(id,_nameController.text,_imageUrlController.text,int.parse(_amountController.text),double.parse(_priceController.text));
                      Navigator.pop(context);
                      
                    },
                    child: Text('Apply Edit'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> alertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(height:150,child:Column(
              children: [
                Column( children: [
                  Container(
                    child: Image.asset('assets/success.png'),
                    width: 100,
                    height: 100,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                ],)


              ],
            ), ),
            content: Container(alignment: Alignment.center,height: 50,child:Text('Add Meal Successfully!!') ,),
            actions: <Widget>[
              Container(child:ElevatedButton(
                child: Text('Ok'),
                onPressed: () {

                },
              ), alignment: Alignment.center,)

            ],
          );
        });
  }
  Future<void> showItemOptions(BuildContext context) async {
    print("In IMG ITEM");
    print(key);
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RenderBox itemBox =  context.findRenderObject() as RenderBox;
    final itemPosition = itemBox.localToGlobal(Offset.zero, ancestor: overlay);

    final selectedOption = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        itemPosition.dx,
        itemPosition.dy,
        itemPosition.dx + itemBox.size.width,
        itemPosition.dy + itemBox.size.height,
      ),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        ),
        PopupMenuItem(
          value: 'addToCart',
          child: Text('Add to Shopping Cart'),
        ),
      ],
    );

    if (selectedOption == 'edit') {
      // Handle edit action
      showEditMealDialog(context);
    } else if (selectedOption == 'delete') {
      // Handle delete action
      showConfirmDialog(context);
    } else if (selectedOption == 'addToCart') {
      // Handle add to cart action
        this.onAddtoShoppingCart();
    }
  }
  @override
  Widget build(BuildContext context) {
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

// Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double heightWithoutSafeArea = height - padding.top - padding.bottom;
// Height (without status bar)
    double heightwithoutStatusBar = height - padding.top;
// Height (without status and toolbar)
    double heightwithoutBoth = height - padding.top - kToolbarHeight;

    return InkWell(
        key: key,
      onTap: () => showItemOptions(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRect(
                    child: Material(
                      color: Colors.grey, // button color
                      child: InkWell(
                        //splashColor: Colors.red, // inkwell color
                        child: SizedBox(
                          width: width * 0.14,
                          height: height * 0.2,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.network(
                              imgURL.toString(),
                              width: width * 0.14,
                              height: height * 0.2,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  ,
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16 * (height * 0.0004 + width * 0.0004),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "\$" + price.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16 * (height * 0.0004 + width * 0.0004),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  )],


              )
            ],
          ),

        ],
      ),
    );
  }
}
class ReorderableListItem extends StatelessWidget {
  final Key key;
  final Widget child;

  const ReorderableListItem({
    required this.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
