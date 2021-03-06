import 'dart:async';

import 'package:TailorsBook/common/buttons.dart';
import 'package:TailorsBook/common/cardBox.dart';
import 'package:TailorsBook/handle_cloud/data_file.dart';
import 'package:TailorsBook/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class AssignWork extends StatefulWidget {
  final String item;
  final String name;
  final String phoneNo;
  AssignWork({this.item, this.name, this.phoneNo});
  @override
  _AssignWorkState createState() =>
      _AssignWorkState(item: this.item, name: this.name, phoneNo: this.phoneNo);
}

class _AssignWorkState extends State<AssignWork> {
  final String item;
  final String name;
  final String phoneNo;
  _AssignWorkState({this.item, this.name, this.phoneNo});
  final TextEditingController _textController = new TextEditingController();

  List items = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void function(int index) {
    print(phoneNo);
    print(this.phoneNo);
    items.removeAt(index);
    setState(() {});
  }

  int branch = 0;
  int val1 = 1;
  int regNo = -1, count = 1;

  Future addItem() async {
    if (regNo != -1) {
      if (await getCheck(branch, regNo, item, count)) {
        print('yes');
        items.add({
          "branch": branch,
          "regNo": regNo,
          "type": this.item,
          "count": count
        });
      } else {
        SnackBar snackBar = SnackBar(
          content: Text(
            'Data set is not correct',
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        Timer(Duration(seconds: 1), () {});
      }
    }
    regNo = -1;
    count = 1;
    val1 = 1;
    _textController.clear();
    setState(() {});
  }

  void onSave() async {
    print(phoneNo);
    if (phoneNo != null) {
      await assignWork(items, phoneNo);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("$name"), //$$$fetch
        actions: [
          if (items.length > 0)
            Container(
              color: items.length > 0 ? Colors.blue[50] : Colors.amber,
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: onSave,
                child: Center(
                    child: Text(
                  'SAVE',
                  style: TextStyle(fontSize: 20),
                )),
              ),
            ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            buildHeader("add_shirt", context),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (builder, index) {
                    return AddItemCard(
                      branch: items[index]['branch'],
                      regNo: items[index]['regNo'],
                      count: items[index]['count'],
                      type: items[index]['type'],
                      function: function,
                      index: index,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.amber[50],
                child: ListView(
                  children: [
                    Container(
                      //color: Colors.yellow,
                      height: 45,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                branch = branch ^ 1;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  branch == 0 ? "A" : "B",
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            height: 50,
                            width: 150,
                            color: Colors.white,
                            child: Form(
                              child: TextFormField(
                                onChanged: (value) {
                                  regNo = int.parse(value);
                                },
                                controller: _textController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: AppLocalizations.of(context)
                                      .translate("reg_no"),
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.only(
                                      bottom: 0, left: 10, right: 10),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              //margin: EdgeInsets.only(left: 40, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  UpdateValueButton(
                                    icon: Icons.remove,
                                    perform: () {
                                      setState(() {
                                        if (val1 > 1) val1--;
                                        count = val1;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        val1.toString(),
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  UpdateValueButton(
                                    icon: Icons.add,
                                    perform: () {
                                      setState(() {
                                        val1++;
                                        count = val1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        await addItem();
                      },
                      child: Container(
                        height: 45,
                        child: Center(
                          child: Text(
                            "ADD ( $item )",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
