import 'package:blood_donation/model/screen_resolution.dart';
import 'package:flutter/material.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({Key? key}) : super(key: key);

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double asr = ScreenResolution().sh / ScreenResolution().sw;
    TabController tabController = TabController(length: 3, vsync: this);
    return Scaffold(
        body: Column(children: <Widget>[
      SizedBox(height: 25.75 * asr),
      const Text("Call Manager",
          style: TextStyle(color: Colors.black, fontSize: 30)),
      SizedBox(
        height: 5.1 * asr,
      ),
      Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 2.58 * asr,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6.2 * asr),
          ),
          child: TabBar(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(6.2 * asr),
              color: Colors.orange,
            ),
            controller: tabController,
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 15.5 * asr),
            tabs: const <Widget>[
              Tab(
                child: Text(
                  "Sign In",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "Hello",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}
