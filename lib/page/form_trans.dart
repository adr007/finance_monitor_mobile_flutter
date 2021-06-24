import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FormTrans extends StatefulWidget {
  @override
  _FormTransState createState() => _FormTransState();
}

class _FormTransState extends State<FormTrans> {
  List subAssetList = List();
  String _selectedSubAsset = "0";
  String _transTipe = "DOWN";
  String _selectedDate = DateTime.now().toString();
  bool _isLoading = false;
  final dateFormat = DateFormat("yyyy-MM-dd");
  ProgressDialog pr;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _transInfo = TextEditingController();
  TextEditingController _transValue = TextEditingController();
  // TextEditingController _transDate = TextEditingController();

  void initState() {
    super.initState();
    // selectedAsset = Get.arguments;
    // if (selectedAsset != null) {
    //   getSelectedAsset(selectedAsset[0]);
    // }
    getSubAssetList();
  }

  void getSubAssetList() async {
    var jsonData = await Data().getSubAsset();
    // print(jsonData);
    setState(() {
      subAssetList = jsonData;
      _selectedSubAsset = subAssetList[0]['sub_id'].toString();
      _isLoading = false;
    });
  }

  void gasSaveTrans() async {
    Data data = new Data();
    Map creds = {
      'trans_id_sub_asset': _selectedSubAsset,
      'trans_status': _transTipe,
      'trans_information': _transInfo.text,
      'trans_value': _transValue.text,
      'trans_date': _selectedDate,
    };
    print(creds);
    Map<String, dynamic> response = await data.saveTransaction(creds: creds);
    // print(response);
    if (response['status']) {
      Get.back(result: 'isFromTransPage');
    } else {
      print("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {

    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
    );

    pr.style(
      message: 'Please Wait..',
      borderRadius: 10.0,
      backgroundColor: Pallete.backgroundColorDarkMode,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressWidget: CircularProgressIndicator(),
      messageTextStyle: TextStyle(color: Colors.white, fontSize: 15),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Add New Transaction",
          style: TextStyle(fontFamily: "SpaceAge", fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigator.pop(context);
            Get.back(result: 'isBack');
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 230,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Pallete.greenTheme3, Pallete.greenTheme2],
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(100))),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Icon(
                      Icons.wb_sunny_outlined,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Pallete.backgroundSoftColorDarkMode
                                .withOpacity(0.8),
                          ),
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  items: subAssetList.map((x) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        x['sub_name'].toString() +
                                            " [" +
                                            x['asset_name'].toString() +
                                            "]",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      value: x['sub_id'].toString(),
                                    );
                                  }).toList(),
                                  value: _selectedSubAsset,
                                  onChanged: (newVal) {
                                    setState(() {
                                      _selectedSubAsset = newVal;
                                    });
                                  },
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 17),
                                  items: [
                                    DropdownMenuItem(
                                      value: "UP",
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.upload_outlined,
                                                color: Colors.green,
                                                size: 19,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Income",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "DOWN",
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.download_outlined,
                                                color: Colors.red,
                                                size: 19,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Spending",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (newValue) {
                                    setState(() {
                                      // FocusScope.of(context).unfocus();
                                      _transTipe = newValue.toString();
                                    });
                                  },
                                  // onTap: () {
                                  //   // FocusScope.of(context).unfocus();
                                  // },
                                  value: _transTipe,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _textInput(
                            controller: _transInfo,
                            hint: "Information",
                            icon: Icons.dashboard),
                        _textInput(
                            controller: _transValue,
                            hint: "Value",
                            icon: Icons.monetization_on_outlined,
                            isNumber: true),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Pallete.backgroundSoftColorDarkMode
                                .withOpacity(0.8),
                          ),
                          child: DateTimeField(
                            format: dateFormat,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                context: context,
                                firstDate: DateTime(2021),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2025),
                              ).then((selectedDate) {
                                _selectedDate = selectedDate.toString();
                              });
                            },
                            initialValue: DateTime.now(),
                            style: TextStyle(color: Colors.grey),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 10, top: 15),
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: Colors.white,
                              ),
                              prefixIconConstraints:
                                  BoxConstraints(minWidth: 60),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 45,
                          child: InkWell(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                await pr.show();
                                await gasSaveTrans();
                                await pr.hide();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 10,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Pallete.greenTheme3,
                                      Pallete.greenTheme2
                                    ],
                                    end: Alignment.centerLeft,
                                    begin: Alignment.centerRight),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _textInput({controller, hint, icon, isNumber = false}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Pallete.backgroundSoftColorDarkMode.withOpacity(0.8),
    ),
    padding: EdgeInsets.only(left: 10),
    child: TextFormField(
      controller: controller,
      validator: (value) => value.isEmpty ? "Must be filled" : null,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      style: TextStyle(color: Colors.white),
    ),
  );
}
