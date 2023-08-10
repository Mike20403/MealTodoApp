import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/components/TabHolderController.dart';

class TabBarWidget extends StatefulWidget {
  TabController? controller;

  
  TabBarWidget(this.controller);

  @override
  State<StatefulWidget> createState() => TabBarState();
}


class TabBarState extends State<TabBarWidget> with TickerProviderStateMixin {


  List<String> _tabs = ["All", "On Sale", "Featured"];
  int? _selectedTabIndex;

  @override
  void dispose() {
    // TODO: implement dispose
    widget.controller!.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    widget.controller = TabController(length: 3, vsync: this);
    _selectedTabIndex = 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // ... (build your TabBar here)
    return TabBar(
      dividerColor: Colors.transparent,
      indicatorWeight: 0.0001,
      indicatorColor: Colors.transparent,
      labelColor: Colors.white,
      controller: widget.controller,
      unselectedLabelColor: Colors.white,
      isScrollable: true,
      labelPadding:
      EdgeInsets.only(left: 0, right: 3),
      tabs: _tabs.map((label) {
        int tabIndex = _tabs.indexOf(label);
        return Padding(
          padding: const EdgeInsets.only(left: 0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = tabIndex;
              });
              widget.controller!.animateTo(tabIndex);
            },
            child: AnimatedContainer(
              duration: Duration(
                  milliseconds:
                  300), // Adjust duration as needed
              color: _selectedTabIndex == tabIndex
                  ? Color.fromARGB(255, 235, 235, 234)
                  : Color.fromARGB(255, 9, 173, 170),
              child: Container(
                width: 100,
                child: Tab(text: '$label'),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

}