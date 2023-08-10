
import 'package:flutter/widgets.dart';
import 'package:flutterproject/responsive/desktop_body.dart';
import 'package:flutterproject/responsive/mobile_body.dart';

class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 375){
          return MobileBody();
        } else {
          return DesktopBody();
        }
      });
  }

}