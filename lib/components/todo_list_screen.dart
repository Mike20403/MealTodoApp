import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterproject/components/TabHolderController.dart';
import 'package:flutterproject/components/add_meal_btn.dart';
import 'package:flutterproject/components/meal_list_item.dart';
import 'package:flutterproject/components/navigation_drawer.dart';
import 'package:flutterproject/components/image_items.dart';
import 'package:flutterproject/components/tab_bar_widget.dart';
import 'package:flutterproject/modals/meal.dart';
import 'package:flutterproject/services/meal.services.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  TodoListScreenState createState() => TodoListScreenState();
}

class TodoListScreenState extends State<TodoListScreen>
    with TickerProviderStateMixin {
  GlobalKey<TodoListScreenState> myKey = GlobalKey();
  List<Meal> meal = [];
  List<(Meal,int)> shoppingCart = [];
  List<int> mealAmount = [];
  List<Meal> filteredItems = [];
  TextEditingController _searchController = TextEditingController();

  // Init Tabbar controller
  TabController? _mealController;
  TabController? _shoppingCartController;
  MealService mealService = MealService();
  double totalCost = 0;
  @override
  void initState() {
    // TODO: implement initState
    _mealController = TabController(length: 3, vsync: this);
    _shoppingCartController = TabController(length: 3, vsync: this);
    fetchMeal();

    super.initState();
  }

  void fetchMeal() {
    mealService.fetchMeal().then((event) {
      if (event.snapshot.value != null) {
        final values = event.snapshot;
        List<Meal> tmpMeal = [];
        values.children.forEach((element) {
          print(element.value);
          tmpMeal.add(Meal.fromSnapshot(element));
        });
        setState(() {
          meal = tmpMeal;
          filteredItems = List.from(meal);
        });
      } else {
        print("No data found in the database.");
      }
    }).catchError((error) {
      print("Error fetching data: $error");
    });
  }

  void _filterItems(String query) {
    print(query);
    setState(() {
      filteredItems = meal
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void calculateTotalCost() {
    double total = 0.0;

    for (var item in shoppingCart) {
      total += item.$1.price * item.$2;
      print(item.$1);
    }

    setState(() {
      totalCost = total;
    });
  }

  Future<dynamic> alertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              height: 150,
              child: Column(
                children: [
                  Column(
                    children: [
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
                    ],
                  )
                ],
              ),
            ),
            content: Container(
              alignment: Alignment.center,
              height: 50,
              child: Text('Add Meal Successfully!!'),
            ),
            actions: <Widget>[
              Container(
                child: ElevatedButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                alignment: Alignment.center,
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    _mealController!.dispose();
    _shoppingCartController!.dispose();
    super.dispose();
  }

  void deleteMeal(Meal meal) {
    setState(() {
      mealService.deleteMeal(meal.id.toString());
      this.meal.removeWhere((item) => item.id == meal.id);
      this.filteredItems.removeWhere((item) => item.id == meal.id);
      // this.filteredItems = this.meal;
      // _filterItems(_searchController.text.toString());
    });
  }

  void _addMeal(Meal meal) {
    this.mealService.addMeal(meal);
    fetchMeal();
    this._searchController.text = '';
  }

  void editMeal(
      num id, num reposID, String name, String url, int amount, double price) {
    setState(() {
      Meal meal =
          this.meal[this.meal.indexWhere((element) => element.id == id)];
      meal.name = name;
      meal.urlImage = url;
      meal.amount = amount;
      meal.price = price;

      mealService.updateMeal(id.toString(), meal);
      fetchMeal();
      this._searchController.text = '';
    });
  }

  addtoShoppingCart(Meal meal) {
    setState(() {
      if (this.shoppingCart.any((element) => element.$1.name == meal.name)) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Align(
            child: Text('Meal has already been added!!! '),
            alignment: Alignment.center,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 20,
              left: 20),
        ));
      } else {
        {
          this.shoppingCart.add((meal,0));

        }
      }
    });
  }

  void removeMeal(int id) {
    setState(() {
      this.shoppingCart.removeWhere((meal) => meal.$1.id == id);

    });
  }

  int determineCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 500).floor(); // Adjust 150 as needed

    return crossAxisCount;
  }

  void showAddMealDialog(BuildContext context) async {
    final _imageUrlController = TextEditingController();
    final _nameController = TextEditingController();
    final _amountController = TextEditingController();
    final _priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Product'),
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
                      num lastIndex = 0;
                      this.meal.forEach((element) {
                        if (lastIndex < element.id) lastIndex = element.id;
                      });

                      _addMeal(Meal(
                          lastIndex + 1,
                          _nameController.text,
                          _imageUrlController.text,
                          int.parse(_amountController.text),
                          double.parse(_priceController.text)));
                      Navigator.pop(context);
                      alertDialog(context);
                    },
                    child: Text('Add Product'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabControllerStateHolder =
        TabControllerStateHolder(_mealController, _shoppingCartController);

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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 67, 87, 86),
          title: Row(
            children: [
              //Items in bar start from here
              const Column(
                children: [Icon(Icons.store)],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Column(
                  children: [
                    Row(children: [
                      Text(
                        "Store: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Food Store",
                      )
                    ])
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: const Column(
                  children: [
                    Row(children: [
                      Text(
                        "Register: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Register 1",
                      )
                    ])
                  ],
                ),
              ),
            ],
          ),
          leading: Builder(
            builder: (context) => Container(
              color: const Color.fromARGB(255, 9, 173,
                  170), // Set the background color of the menu icon here
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(Icons.notifications),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(Icons.fullscreen_outlined),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/noavt.jpg'),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 50),
                  child: const Text("Test Test"),
                ),
                Builder(
                    builder: (context) => Container(
                          width: 70,
                          padding: const EdgeInsets.all(5),
                          color: Colors.red,
                          child: const Column(
                            children: [Icon(Icons.logout), Text("LOGOUT")],
                          ),
                        )),
              ],
            )
          ],
        ),
        drawer: NavigationDrawerWidget(),
        body: Container(
          color: Colors.white,
          child: Row(
            //Data on first column start from here
            children: [
              Expanded(
                flex: 5, // 50%
                child: Column(
                  children: [
                    // Web logo & Search bar row here !
                    Container(
                        child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2, child: Image.asset('assets/logo.png')),
                          Expanded(
                              flex: 7,
                              child: TextField(
                                  controller: _searchController,
                                  onChanged: _filterItems,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: BorderSide(
                                            color: Colors.teal, width: 0.0),
                                      ),
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'Search meal',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.teal))))),
                          Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                height: 50,
                                color: Colors.teal,
                                child: const Icon(
                                  Icons.category_outlined,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    )),
                    //Web tab page here !!
                    Row(
                      children: [
                        Container(
                            height: 33,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: TabBarWidget(
                                  tabControllerStateHolder.mealController),
                            )),
                        Container(
                            width: 150,
                            height: 33,
                            color: Color.fromARGB(255, 9, 173, 170),
                            margin: EdgeInsets.only(left: 0, bottom: 1),
                            child: SizedBox(
                                child: ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 9, 173, 170),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero))),
                              onPressed: () {},
                              label: Text("Add Product"),
                            ))),
                        Container(
                            width: 150,
                            height: 33,
                            color: Color.fromARGB(255, 9, 173, 170),
                            margin: EdgeInsets.only(left: 3, bottom: 1),
                            child: SizedBox(
                                child: ElevatedButton.icon(
                              icon: Icon(Icons.qr_code_scanner),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 9, 173, 170),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero))),
                              onPressed: () {},
                              label: Text("Scan Product"),
                            )))
                      ],
                    ),

                    Container(
                      color: Color.fromARGB(255, 235, 235, 234),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height -
                                  300, // Full screen height
                              child: TabBarView(
                                controller: _mealController,
                                children: [
                                  Container(
                                    child: ReorderableGridView.builder(
                                      padding: const EdgeInsets.only(top: 10),
                                      itemCount: filteredItems.length + 1,
                                      itemBuilder: (context, i) {
                                        if (i == 0) {
                                          return AddMealBtn(
                                              key: ValueKey(i),
                                              onClickAdd: () {
                                                showAddMealDialog(
                                                  context,
                                                );
                                              });
                                        }

                                        var catData = filteredItems[i - 1];

                                        return ImageItem(
                                          key: ValueKey(i),
                                          catData.id,
                                          catData.name,
                                          catData.urlImage,
                                          catData.amount,
                                          catData.price,
                                          onAddtoShoppingCart: () {
                                            addtoShoppingCart(
                                                filteredItems[i - 1]);
                                          },
                                          onDelete: () {
                                            deleteMeal(filteredItems[i - 1]);
                                          },
                                          onEdit:
                                              (id, name, url, amount, price) {
                                            print(i);
                                            editMeal(id, i, name, url, amount,
                                                price);
                                          },
                                        );
                                      },
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            determineCrossAxisCount(context),
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      onReorder: (int oldIndex, int newIndex) {
                                        print(oldIndex);
                                        print(newIndex);
                                        setState(() {
                                          if (oldIndex > 0 && newIndex > 0) {
                                            final element = filteredItems
                                                .removeAt(oldIndex - 1);

                                            filteredItems.insert(
                                                newIndex - 1, element);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: Color.fromARGB(255, 235, 235, 234),
                                    child: Text("Tab View "),
                                  ),
                                  Container(
                                    color: Color.fromARGB(255, 235, 235, 234),
                                    child: Text("Tab View"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              VerticalDivider(
                  color: Color.fromARGB(255, 235, 235, 234), width: 0.1),

              //Shopping Cart Section

              Expanded(
                  flex: 5, // 50%
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        color: Colors.white,
                        child: TabBarWidget(
                            tabControllerStateHolder.shoppingCartController),
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                height: MediaQuery.of(context).size.height -
                                    500, // Full screen height
                                child: TabBarView(
                                  controller: _shoppingCartController,
                                  children: [
                                    shoppingCart.isEmpty
                                        ? Container(
                                            margin: EdgeInsets.only(top: 100),
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.shopping_cart,
                                                  size: 64,
                                                  color: Colors.grey,
                                                ),
                                                Text(
                                                  "Shopping cart is empty",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: ListView.separated(
                                              itemCount: shoppingCart.length,
                                              itemBuilder: (context, index) {
                                                return MealListItem(
                                                  shoppingCart[index],
                                                  onRemove: () {
                                                    print("ID: ");
                                                    print(index);
                                                    removeMeal(
                                                        shoppingCart[index].$1.id.toInt());
                                                    calculateTotalCost();
                                                  },
                                                  onPriceAmountChanged:
                                                      (double price,
                                                          int amount) {
                                                    // Update the price and amount in the shopping cart
                                                    // Recalculate the total cost
                                                        shoppingCart[index] = (shoppingCart[index].$1,amount);
                                                    calculateTotalCost();
                                                  },
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Divider();
                                              },
                                            ),
                                          ),
                                    Container(
                                      color: Colors.white,
                                      child: Text("Tab View 2"),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      child: Text("Tab View 3"),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child:
                                Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "SUBTOTAL",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text("\$ ${totalCost.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            overflow: TextOverflow.ellipsis,
                                          ))
                                    ],
                                  ),
                                  Divider(
                                    color: Color.fromARGB(255, 235, 235, 234),
                                    thickness: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "TOTAL",
                                        style: TextStyle(
                                          fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 9, 173, 170),),
                                      ),
                                      Text("\$ ${totalCost.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 9, 173, 170),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            overflow: TextOverflow.ellipsis,
                                          ))
                                    ],
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.end
                                    ,children: [

                                    Container(

                                        width: 250,
                                        height: 33,
                                        color: Color.fromARGB(255, 9, 173, 170),
                                        margin: EdgeInsets.only(left: 0, bottom: 1,top:55),
                                        child: SizedBox(
                                            child: ElevatedButton.icon(
                                              icon: Icon(Icons.add),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                  Color.fromARGB(255,198,83,56),
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.all(Radius.zero))),
                                              onPressed: () {},
                                              label: Text("Empty Cart ",style: TextStyle(fontWeight: FontWeight.bold)),
                                            )))
                                  ],),
                                  Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [ Container(

                                      width: 130,
                                      height: 100,
                                      color: Color.fromARGB(255, 9, 173, 170),
                                      margin: EdgeInsets.only(left: 0, bottom: 1,top:20),
                                      child: SizedBox(
                                          child: ElevatedButton.icon(
                                            icon: Icon(Icons.message),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Color.fromARGB(255,76,76,77),
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.zero))),
                                            onPressed: () {},
                                            label: Text("ADD NOTE",style: TextStyle(fontWeight: FontWeight.bold),),
                                          ))), Container(

                                      width: 130,
                                      height: 100,
                                      color: Color.fromARGB(255, 9, 173, 170),
                                      margin: EdgeInsets.only(left: 0, bottom: 1,top:20),
                                      child: SizedBox(
                                          child: ElevatedButton.icon(
                                            icon: Icon(Icons.discount),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Color.fromARGB(255, 9, 173, 170),
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.zero))),
                                            onPressed: () {},
                                            label: Text("ADD FEE OR DISCOUNT",style: TextStyle(fontWeight: FontWeight.bold)),
                                          ))), Container(

                                      width: 130,
                                      height: 100,
                                      color: Color.fromARGB(255, 9, 173, 170),
                                      margin: EdgeInsets.only(left: 0, bottom: 1,top:20),
                                      child: SizedBox(
                                          child: ElevatedButton.icon(
                                            icon: Icon(Icons.receipt),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Color.fromARGB(255, 9, 173, 170),
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.zero))),
                                            onPressed: () {},
                                            label: Text("APPLY COUPON",style: TextStyle(fontWeight: FontWeight.bold)),
                                          ))), Container(

                                      width: 130,
                                      height: 100,
                                      color: Color.fromARGB(255, 9, 173, 170),
                                      margin: EdgeInsets.only(left: 0, bottom: 1,top:20),
                                      child: SizedBox(
                                          child: ElevatedButton.icon(
                                            icon: Icon(Icons.local_shipping),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Color.fromARGB(255, 9, 173, 170),
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.zero))),
                                            onPressed: () {},
                                            label: Text("SHIPPING",style: TextStyle(fontWeight: FontWeight.bold)),
                                          ))),Container(

                                      width: 130,
                                      height: 100,
                                      color: Color.fromARGB(255, 9, 173, 170),
                                      margin: EdgeInsets.only(left: 0, bottom: 1,top:20),
                                      child: SizedBox(
                                          child: ElevatedButton.icon(
                                            icon: Icon(Icons.shopping_cart),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Color.fromARGB(255,225,152,20),
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.zero))),
                                            onPressed: () {},
                                            label: Text("SUSPEND & SAVE CART",style: TextStyle(fontWeight: FontWeight.bold)),
                                          ))),Container(

                                      width: 250,
                                      height: 100,
                                      color: Color.fromARGB(255, 9, 173, 170),
                                      margin: EdgeInsets.only(left: 0, bottom: 1,top:20),
                                      child: SizedBox(
                                          child: ElevatedButton.icon(
                                            icon: Icon(Icons.payment),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Color.fromARGB(255,160,166,1),
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.zero))),
                                            onPressed: () {},
                                            label: Text("PAY",style: TextStyle(fontWeight: FontWeight.bold)),
                                          )))],),
                                ],)

                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
