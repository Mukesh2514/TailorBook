import 'dart:async';

import 'package:TailorsBook/locale/app_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:TailorsBook/common/buttons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:toast/toast.dart';

DateTime bookingDate = DateTime.now();
DateTime selectedDate = bookingDate;

FirebaseFirestore db = FirebaseFirestore.instance;

class RegisterNewData extends StatefulWidget {
  final int branch;
  RegisterNewData({this.branch});
  @override
  _RegisterNewDataState createState() =>
      _RegisterNewDataState(branch: this.branch);
}

class _RegisterNewDataState extends State<RegisterNewData> {
  int branch;
  _RegisterNewDataState({this.branch});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String showDate;
  int regNo;
  bool dateSelected = false;
  bool update = false;
  bool value1 = false,
      value2 = false,
      value3 = false,
      value4 = false,
      value5 = false,
      value6 = false,
      value7 = false,
      value8 = false,
      value9 = false,
      value10 = false;
  int val1 = 0,
      val2 = 0,
      val3 = 0,
      val4 = 0,
      val5 = 0,
      val6 = 0,
      val7 = 0,
      val8 = 0,
      val9 = 0,
      val10 = 0;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(), // This will change to light theme.
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateSelected = true;
        showDate =
            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      });
  }

  addProduct(bool value, var path, int count) {
    if (value) {
      path.doc("$regNo").get().then((snapShot) => {
            if (snapShot.exists)
              {}
            else
              {
                path.doc("$regNo").set({
                  "reg_no": regNo,
                  "count": count,
                  "is_complete": false,
                  "status": [
                    for (int i = 0; i < count; i++) "uncut",
                  ],
                }),
              }
          });
    }
  }

  submit() async {
    print("REG NO. : $regNo");
    if (regNo == null ||
        regNo < 0 ||
        regNo > 100000 ||
        (value1 == false &&
            value2 == false &&
            value3 == false &&
            value4 == false &&
            value5 == false &&
            value6 == false &&
            value7 == false &&
            value8 == false)) {
      SnackBar snackBar = SnackBar(
        content: Text("Entry format is not correct!"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 1), () {});
      return;
    }
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      var regPath = db
          .collection("company")
          .doc(branch == 0 ? "branchA" : "branchB")
          .collection("register");
      var products = db
          .collection("company")
          .doc(branch == 0 ? "branchA" : "branchB")
          .collection("products")
          .doc("products");
      var coatPath = products.collection("coat");
      var pentPath = products.collection("pent");
      var shirtPath = products.collection("shirt");
      var achkanPath = products.collection("achkan");
      var jacketPath = products.collection("jacket");
      var kurtaPath = products.collection("kurta");
      var pajamaPath = products.collection("pajama");
      var otherPath = products.collection("others");
      int check = 0; //to check duplicity of register number
      await regPath.doc("$regNo").get().then((snapShot) => {
            if (snapShot.exists)
              {
                check++,
                print("doc already exists"),
              }
            else
              {
                regPath.doc("$regNo").set({
                  "reg_no": regNo,
                  "booking_date": bookingDate,
                  "return_date": selectedDate,
                  if (value1) "coat": val1,
                  if (value2) "pent": val2,
                  if (value3) "shirt": val3,
                  if (value4) "jacket": val4,
                  if (value5) "kurta": val5,
                  if (value6) "pajama": val6,
                  if (value7) "achkan": val7,
                  if (value8) "others": val8,
                  "is_complete": false
                }),
                addProduct(value1, coatPath, val1),
                addProduct(value2, pentPath, val2),
                addProduct(value3, shirtPath, val3),
                addProduct(value4, jacketPath, val4),
                addProduct(value5, kurtaPath, val5),
                addProduct(value6, pajamaPath, val6),
                addProduct(value7, achkanPath, val7),
                addProduct(value8, otherPath, val8),
                print("done")
              }
          });
      if (check == 0) {
        SnackBar snackBar = SnackBar(
          content: Text(
              AppLocalizations.of(context).translate("save_detail_of") +
                  " ${regNo.toString()}"),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        Timer(Duration(seconds: 1), () {
          Navigator.pop(context, regNo.toString());
        });
      } else {
        Toast.show(
            AppLocalizations.of(context).translate("reg_no_exist"), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      }
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("t_register") +
              (branch == 0 ? "A" : "B"),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 30.0, top: 10, bottom: 10),
            child: Container(
              width: 120,
              child: RaisedButton(
                child: Text(
                  update == true
                      ? AppLocalizations.of(context).translate("update")
                      : AppLocalizations.of(context).translate("new"),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                onPressed: () {
                  setState(() {
                    if (update == true) {
                      update = false;
                    } else {
                      update = true;
                    }
                  });
                },
                // shape: CircleBorder(
                //   side: BorderSide(color: Colors.blue),
                // ),
                color: Colors.black38,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    height: 90,
                    //decoration: BoxDecoration(color: Colors.yellow),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Center(
                              child: RaisedButton(
                                  child: Container(
                                    margin: EdgeInsets.all(9.0),
                                    child: Text(
                                      branch == 0 ? "A" : "B",
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w500,
                                          color: branch == 0
                                              ? Colors.deepPurple
                                              : Colors.red[700]),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (branch == 0) {
                                        branch = 1;
                                      } else {
                                        branch = 0;
                                      }
                                    });
                                  },
                                  shape: CircleBorder(
                                    side: BorderSide(color: Colors.black),
                                  ),
                                  color: Colors.white)),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Form(
                              // here we associate a form key with our form with the help of key
                              key: _formKey,
                              autovalidate:
                                  true, // to immediate execute validator
                              // as soon as user typed
                              child: TextFormField(
                                  validator: (val) {
                                    if (val.trim().isEmpty)
                                      return AppLocalizations.of(context)
                                          .translate("must_not_empty");
                                    else if (val.trim().length > 6)
                                      return AppLocalizations.of(context)
                                          .translate("wrong_entry");
                                    else
                                      return null;
                                  },
                                  onChanged: (val) => regNo = int.parse(val),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: AppLocalizations.of(context)
                                        .translate("reg_no"),
                                    labelStyle: TextStyle(fontSize: 15.0),
                                    hintText: AppLocalizations.of(context)
                                        .translate("reg_no_full"),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey,
                  height: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 30,
                        child: SvgPicture.asset(
                          'assets/images/coat.svg',
                          height: 30,
                          width: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context).translate("coat"),
                      style: TextStyle(fontSize: 20),
                    )),
                    Expanded(
                      child: value1 == true
                          ? Container(
                              child: Row(
                                children: [
                                  UpdateValueButton(
                                    icon: Icons.remove,
                                    perform: () {
                                      setState(() {
                                        if (val1 > 1) val1--;
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  UpdateValueButton(
                                    icon: Icons.add,
                                    perform: () {
                                      setState(() {
                                        val1++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Checkbox(
                        value: this.value1,
                        onChanged: (bool value) {
                          setState(() {
                            if (this.value1 == false) {
                              this.value1 = true;
                              val1 = 1;
                            } else {
                              this.value1 = false;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 30,
                        child: SvgPicture.asset(
                          'assets/images/pent.svg',
                          height: 27,
                          width: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context).translate("pent"),
                      style: TextStyle(fontSize: 20),
                    )),
                    Expanded(
                      child: value2 == true
                          ? Container(
                              child: Row(
                                children: [
                                  UpdateValueButton(
                                    icon: Icons.remove,
                                    perform: () {
                                      setState(() {
                                        if (val2 > 1) val2--;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        val2.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  UpdateValueButton(
                                    icon: Icons.add,
                                    perform: () {
                                      setState(() {
                                        val2++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Checkbox(
                          value: this.value2,
                          onChanged: (bool value) {
                            setState(() {
                              if (this.value2 == false) {
                                this.value2 = true;
                                val2 = 1;
                              } else {
                                this.value2 = false;
                              }
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 11),
                      child: Container(
                        width: 30,
                        child: SvgPicture.asset(
                          'assets/images/shirt.svg',
                          height: 30,
                          width: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context).translate("shirt"),
                      style: TextStyle(fontSize: 20),
                    )),
                    Expanded(
                      child: value3 == true
                          ? Container(
                              child: Row(
                                children: [
                                  UpdateValueButton(
                                    icon: Icons.remove,
                                    perform: () {
                                      setState(() {
                                        if (val3 > 1) val3--;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        val3.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  UpdateValueButton(
                                    icon: Icons.add,
                                    perform: () {
                                      setState(() {
                                        val3++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Checkbox(
                          value: this.value3,
                          onChanged: (bool value) {
                            setState(() {
                              if (this.value3 == false) {
                                this.value3 = true;
                                val3 = 1;
                              } else {
                                this.value3 = false;
                              }
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 30,
                        child: SvgPicture.asset(
                          'assets/images/jacket.svg',
                          height: 30,
                          width: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context).translate("jacket"),
                      style: TextStyle(fontSize: 20),
                    )),
                    Expanded(
                      child: value4 == true
                          ? Container(
                              child: Row(
                                children: [
                                  UpdateValueButton(
                                    icon: Icons.remove,
                                    perform: () {
                                      setState(() {
                                        if (val4 > 1) val4--;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        val4.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  UpdateValueButton(
                                    icon: Icons.add,
                                    perform: () {
                                      setState(() {
                                        val4++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Checkbox(
                          value: this.value4,
                          onChanged: (bool value) {
                            setState(() {
                              if (this.value4 == false) {
                                this.value4 = true;
                                val4 = 1;
                              } else {
                                this.value4 = false;
                              }
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 14),
                      child: Container(
                        width: 20,
                        child: SvgPicture.asset(
                          'assets/images/kurta.svg',
                          height: 30,
                          width: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context).translate("kurta"),
                      style: TextStyle(fontSize: 20),
                    )),
                    Expanded(
                      child: value5 == true
                          ? Container(
                              child: Row(
                                children: [
                                  UpdateValueButton(
                                    icon: Icons.remove,
                                    perform: () {
                                      setState(() {
                                        if (val5 > 1) val5--;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        val5.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  UpdateValueButton(
                                    icon: Icons.add,
                                    perform: () {
                                      setState(() {
                                        val5++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Checkbox(
                          value: this.value5,
                          onChanged: (bool value) {
                            setState(() {
                              if (this.value5 == false) {
                                this.value5 = true;
                                val5 = 1;
                              } else {
                                this.value5 = false;
                              }
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 30,
                        child: SvgPicture.asset(
                          'assets/images/pajama.svg',
                          height: 30,
                          width: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context).translate("pajama"),
                      style: TextStyle(fontSize: 20),
                    )),
                    Expanded(
                      child: value6 == true
                          ? Container(
                              child: Row(
                                children: [
                                  UpdateValueButton(
                                    icon: Icons.remove,
                                    perform: () {
                                      setState(() {
                                        if (val6 > 1) val6--;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        val6.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  UpdateValueButton(
                                    icon: Icons.add,
                                    perform: () {
                                      setState(() {
                                        val6++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Checkbox(
                          value: this.value6,
                          onChanged: (bool value) {
                            setState(() {
                              if (this.value6 == false) {
                                this.value6 = true;
                                val6 = 1;
                              } else {
                                this.value6 = false;
                              }
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 30,
                        child: SvgPicture.asset(
                          'assets/images/achkan.svg',
                          height: 30,
                          width: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context).translate("achkan"),
                      style: TextStyle(fontSize: 20),
                    )),
                    Expanded(
                      child: value7 == true
                          ? Container(
                              child: Row(
                                children: [
                                  UpdateValueButton(
                                    icon: Icons.remove,
                                    perform: () {
                                      setState(() {
                                        if (val7 > 1) val7--;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        val7.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  UpdateValueButton(
                                    icon: Icons.add,
                                    perform: () {
                                      setState(() {
                                        val7++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Checkbox(
                          value: this.value7,
                          onChanged: (bool value) {
                            setState(() {
                              if (this.value7 == false) {
                                this.value7 = true;
                                val7 = 1;
                              } else {
                                this.value7 = false;
                              }
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 30,
                        child: SvgPicture.asset(
                          'assets/images/others.svg',
                          height: 30,
                          width: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      AppLocalizations.of(context).translate("other"),
                      style: TextStyle(fontSize: 20),
                    )),
                    Expanded(
                      child: value8 == true
                          ? Container(
                              child: Row(
                                children: [
                                  UpdateValueButton(
                                    icon: Icons.remove,
                                    perform: () {
                                      setState(() {
                                        if (val8 > 1) val8--;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 30,
                                    width: 40,
                                    child: Center(
                                      child: Text(
                                        val8.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  UpdateValueButton(
                                    icon: Icons.add,
                                    perform: () {
                                      setState(() {
                                        val8++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Checkbox(
                          value: this.value8,
                          onChanged: (bool value) {
                            setState(() {
                              if (this.value8 == false) {
                                this.value8 = true;
                                val8 = 1;
                              } else {
                                this.value8 = false;
                              }
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 2,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          AppLocalizations.of(context).translate("return_date"),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: dateSelected == true
                          ? Text(showDate,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepPurple,
                              ))
                          : Container(),
                    ),
                    Container(
                      padding: const EdgeInsets.all(0),
                      margin: EdgeInsets.only(right: 10),
                      width: 55,
                      child: Center(
                        child: RaisedButton(
                            color: Colors.white,
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: Icon(
                              Icons.date_range,
                              //color: Colors.amber,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 2,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      color: branch == 0 ? Colors.deepPurple : Colors.red[700],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).translate("save"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).translate("cancel"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
