import 'package:flutter/material.dart';

class DrawerTab extends StatelessWidget {
  const DrawerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/icons/ww_logo.png"),
                scale: 5,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 1,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 100,
                  child: Text(
                    "Options",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.history_outlined),
            title: Text("History"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.bookmark_border_outlined),
            title: Text("Bookmark"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text("Settings"),
          ),
        ),
        // Card(
        //   child: ListTile(
        //     leading: Icon(Icons.person_outline_outlined),
        //     title: Text("Profile"),
        //   ),
        // ),
        // SizedBox(
        //   height: 15,
        // ),
        // ListTile(
        //   title: Container(
        //     height: 40,
        //     alignment: Alignment.center,
        //     decoration: BoxDecoration(
        //       color: Colors.red,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: Text(
        //       "Logout",
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
