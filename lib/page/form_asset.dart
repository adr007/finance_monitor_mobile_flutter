import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FormAsset extends StatefulWidget {
  @override
  _FormAssetState createState() => _FormAssetState();
}

class _FormAssetState extends State<FormAsset> {
  List assetsList = [];
  Data data = new Data();
  String _selectedAsset = "1";
  String subId = "";
  bool _isLoading = false;
  bool _isLoadingGetAsset = false;
  bool _isAdd = true;
  ProgressDialog pr;
  List selectedAsset = null;
  Map<String, dynamic> assetDetail = null;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _asetNameControl = TextEditingController();
  TextEditingController _asetValueControl = TextEditingController();
  TextEditingController _asetVendorControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedAsset = Get.arguments;
    if (selectedAsset != null) {
      getSelectedAsset(selectedAsset[0]);
    }
    getAssetsList();
  }

  void getSelectedAsset(String idSub) async {
    _isLoadingGetAsset = true;
    Map creds = {
      'sub_id': idSub,
    };
    Map<String, dynamic> response = await data.getAssetDetail(creds: creds);
    if (response['status']) {
      assetDetail = response['data'];
      fillForm();
      _isAdd = false;
    }
    _isLoadingGetAsset = false;
  }

  void fillForm() {
    _selectedAsset = assetDetail['sub_id_asset'].toString();
    _asetNameControl.text = assetDetail['sub_name'].toString();
    _asetValueControl.text = assetDetail['sub_value'].toString();
    _asetVendorControl.text = assetDetail['sub_vendor'].toString();
    subId = assetDetail['sub_id'].toString();
  }

  void getAssetsList() async {
    var jsonData = await Data().getAssetsList();
    setState(() {
      assetsList = jsonData;
      _isLoading = false;
    });
  }

  void gasSaveAsset() async {
    Map creds = {
      'sub_id': subId,
      'sub_id_asset': _selectedAsset,
      'sub_name': _asetNameControl.text,
      'sub_value': _asetValueControl.text,
      'sub_vendor': _asetVendorControl.text,
    };
    Map<String, dynamic> response = await data.saveAsset(isAdd: _isAdd ,creds: creds);
    print(response);
    if (response['status']) {
      Get.back();
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
      backgroundColor: Pallete.backgroundColor,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressWidget: CircularProgressIndicator(),
      messageTextStyle: TextStyle(color: Colors.grey, fontSize: 15),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _isAdd ? "Add New Asset" : "Edit Asset",
          style: TextStyle(fontFamily: "SpaceAge", fontSize: 21),
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
      body: _isLoadingGetAsset
          ? Container(
              color: Pallete.backgroundColor,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amberAccent,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Bg2-w.png"),
                  fit: BoxFit.cover,
                ),
                // gradient: LinearGradient(
                //   colors: [Pallete.backgroundColor, Colors.white],
                //   begin: Alignment.centerLeft,
                //   end: Alignment.centerRight),
              ),
              child: Column(
                children: [
                  Container(
                    height: 230,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Pallete.linerUp1, Pallete.greenTheme2],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100))),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey
                                      .withOpacity(0.2),
                                ),
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _isLoading
                                        ? Container()
                                        : DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              items: assetsList.map((x) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    x['asset_name'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  value:
                                                      x['asset_id'].toString(),
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _selectedAsset = newVal;
                                                });
                                              },
                                              value: _selectedAsset,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              _textInput(
                                  controller: _asetNameControl,
                                  hint: "Asset Name",
                                  icon: Icons.dashboard),
                              _textInput(
                                  controller: _asetValueControl,
                                  hint: "Asset Value",
                                  icon: Icons.monetization_on_outlined,
                                  isNumber: true),
                              _textInput(
                                  controller: _asetVendorControl,
                                  hint: "Asset Vendor",
                                  icon: Icons.wb_cloudy_outlined),
                              Container(
                                margin: EdgeInsets.only(top: 50),
                                height: 45,
                                child: InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState.validate()) {
                                      await pr.show();
                                      await gasSaveAsset();
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
      color: Colors.grey.withOpacity(0.2),
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
      style: TextStyle(color: Colors.white),
    ),
  );
}
