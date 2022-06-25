// import 'dart:convert';
// import 'dart:developer';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:adr_finance_app/controllers/transaction_controller.dart';

class FormTrans extends StatefulWidget {
  @override
  _FormTransState createState() => _FormTransState();
}

class _FormTransState extends State<FormTrans> {
  List subAssetList = [];
  List tagList = [];
  String _selectedSubAsset = "0";
  String _selectedTag = "100";
  String _transTipe = "DOWN";
  String _selectedDate = DateTime.now().toString();
  bool _isLoading = false;
  final dateFormat = DateFormat("yyyy-MM-dd");
  ProgressDialog pr;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _transInfo = TextEditingController();
  TextEditingController _transValue = TextEditingController();
  final TransactionController transController = Get.put(TransactionController());
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
    var jsonData2 = await Data().getAllTag();
    // print(jsonData);
    setState(() {
      subAssetList = jsonData;
      tagList = jsonData2;
      _selectedSubAsset = subAssetList[0]['sub_id'].toString();
      _selectedTag = tagList[tagList.length-1]['tag_kode'].toString();
      _isLoading = false;
    });
  }

  void gasSaveTrans() async {
    Data data = new Data();
    Map creds = {
      'trans_id_sub_asset': _selectedSubAsset,
      'trans_status': _transTipe,
      'trans_tag': _selectedTag,
      'trans_information': _transInfo.text,
      'trans_value': _transValue.text,
      'trans_date': _selectedDate,
    };
    print(creds);
    Map<String, dynamic> response = await data.saveTransaction(creds: creds);
    // print(response);
    if (response['status']) {
      transController.refresh();
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
            transController.refresh();
            Get.back(result: 'isBack');
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Bg2-w.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 240,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Pallete.linerUp1, Pallete.greenTheme2],
                      end: Alignment.centerLeft,
                      begin: Alignment.centerRight),
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
                            color: Pallete.backgroundColor
                                .withOpacity(0.7),
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
                                  isExpanded: true,
                                  items: tagList.map((x) {
                                    return DropdownMenuItem(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.tag,
                                                color: Colors.amber,
                                                size: 17,
                                              ),
                                            ),
                                            TextSpan(
                                              text: x['tag_name'].toString(),
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      value: x['tag_kode'].toString(),
                                    );
                                  }).toList(),
                                  value: _selectedTag,
                                  onChanged: (newVal) {
                                    setState(() {
                                      _selectedTag = newVal;
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
                                                size: 17,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Spending",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
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
                            color: Pallete.backgroundColor
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
                              // ignore: missing_return
                              ).then((selectedDate) {
                                setState(() {
                                  _selectedDate = selectedDate.toString();
                                  return 0;
                                });
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
                                color: Colors.grey,
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
                                      Pallete.linerUp1,
                                      Pallete.greenTheme2
                                    ],
                                    end: Alignment.centerRight,
                                    begin: Alignment.centerLeft),
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
      color: Pallete.backgroundColor.withOpacity(0.8),
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
          color: Colors.grey,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
      ),
      style: TextStyle(color: Colors.grey),
    ),
  );
}
