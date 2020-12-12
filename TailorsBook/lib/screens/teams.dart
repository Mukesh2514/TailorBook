import 'dart:async';
import 'package:TailorsBook/signin.dart';
import 'package:flutter/material.dart';
import 'package:TailorsBook/common/nav_drower.dart';
import 'package:TailorsBook/common/cardBox.dart';
import 'package:TailorsBook/handle_cloud/data_file.dart';
import 'package:TailorsBook/screens/register_new.dart';
import 'package:flutter/services.dart';
import 'package:TailorsBook/screens/on_working.dart';
import 'package:flutter_svg/flutter_svg.dart';

List teamA = [1, 1, 1, 1, 1, 1, 1];

class TeamMembers extends StatefulWidget {
  @override
  _TeamMembersState createState() => _TeamMembersState();
}

class _TeamMembersState extends State<TeamMembers> {
  profile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => OnWork()));
  }

  cutterProfile() {}
  tailorProfile() {}
  salesmanProfile() {}

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      appBar: AppBar(
        title: Text("Team Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(child: Icon(Icons.content_cut)),
                  TextSpan(
                      text: "  CUTTER",
                      style: TextStyle(fontSize: 25, color: Colors.black)),
                ]),
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[100],
                  ),
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[100],
                  ),
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[100],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 30, bottom: 10),
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                      child: SvgPicture.asset(
                    "assets/images/coat.svg",
                    height: 30,
                  )),
                  TextSpan(
                      text: "  COAT MAKER",
                      style: TextStyle(fontSize: 25, color: Colors.black)),
                ]),
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[200],
                  ),
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[200],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 30, bottom: 10),
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                      child: SvgPicture.asset(
                    "assets/images/trouser.svg",
                    height: 30,
                  )),
                  TextSpan(
                      text: "  PENT MAKER",
                      style: TextStyle(fontSize: 25, color: Colors.black)),
                ]),
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[300],
                  ),
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[300],
                  ),
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[300],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 30, bottom: 10),
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                      child: Image.asset(
                    "assets/images/shirt_.png",
                    height: 30,
                  )),
                  TextSpan(
                      text: "  SHIRT MAKER",
                      style: TextStyle(fontSize: 25, color: Colors.black)),
                ]),
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[400],
                  ),
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[400],
                  ),
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[400],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 30, bottom: 10),
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                    child: Icon(Icons.person),
                  ),
                  TextSpan(
                      text: "  SALESMEN",
                      style: TextStyle(fontSize: 25, color: Colors.black)),
                ]),
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[600],
                  ),
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[600],
                  ),
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[600],
                  ),
                  PersonInfo(
                    name: "Amitabh Ji",
                    image: Image.asset("assets/images/person.png"),
                    onPressed: profile,
                    color: Colors.purple[600],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}