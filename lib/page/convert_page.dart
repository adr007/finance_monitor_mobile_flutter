import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/controllers/sub_asset_controller.dart';
import 'package:adr_finance_app/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ConvertPage extends StatefulWidget {
  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  List subAssetList = [];
  String _selectedSubAsset = "0";
  String _selectedSubAsset2 = "0";
  bool _isLoading = true;
  ProgressDialog pr;
  bool _isAda = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _transValue = TextEditingController();
  final SubAssetController subAssetController = Get.put(SubAssetController());

  void getSubAssetList() async {
    var jsonData = await Data().getSubAsset();
    // print(jsonData);

    setState(() {
      subAssetList = jsonData;
      if (jsonData.length > 0) {
        _isAda = true;
        _selectedSubAsset = subAssetList[0]['sub_id'].toString();
        _selectedSubAsset2 = subAssetList[0]['sub_id'].toString();
      }
      _isLoading = false;
    });
  }

  void initState() {
    super.initState();
    // _isLoading = true;
    getSubAssetList();
  }

  Future<void> gasConvert() async {
    _isLoading = true;
    Data data = new Data();
    Map creds = {
      'trans_id_sub_asset1': _selectedSubAsset,
      'trans_id_sub_asset2': _selectedSubAsset2,
      'trans_value': _transValue.text,
    };
    print(creds);
    Map<String, dynamic> response = await data.doConvert(creds: creds);
    // print(response);
    _isLoading = false;
    if (response['status']) {
      subAssetController.refresh();
      Get.back(result: 'isFromConvert');
    } else {
      setState(() {});
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
          "Convert Asset",
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
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Icon(
                      Icons.repeat,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Center(
                      child: Text(
                        "Loading .. ..",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                        child: _isAda
                            ? Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "From :",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color: Pallete.backgroundColor
                                                .withOpacity(0.7),
                                          ),
                                          padding: EdgeInsets.only(left: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  items: subAssetList.map((x) {
                                                    return DropdownMenuItem(
                                                      child: Text(
                                                        x['sub_name']
                                                                .toString() +
                                                            " [" +
                                                            x['asset_name']
                                                                .toString() +
                                                            "]",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      value: x['sub_id']
                                                          .toString(),
                                                    );
                                                  }).toList(),
                                                  value: _selectedSubAsset,
                                                  onChanged: (newVal) {
                                                    setState(() {
                                                      _selectedSubAsset =
                                                          newVal;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "To :",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color: Pallete.backgroundColor
                                                .withOpacity(0.7),
                                          ),
                                          padding: EdgeInsets.only(left: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  items: subAssetList.map((x) {
                                                    return DropdownMenuItem(
                                                      child: Text(
                                                        x['sub_name']
                                                                .toString() +
                                                            " [" +
                                                            x['asset_name']
                                                                .toString() +
                                                            "]",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      value: x['sub_id']
                                                          .toString(),
                                                    );
                                                  }).toList(),
                                                  value: _selectedSubAsset2,
                                                  onChanged: (newVal) {
                                                    setState(() {
                                                      _selectedSubAsset2 =
                                                          newVal;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Value :",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color:
                                                Colors.amber.withOpacity(0.7),
                                          ),
                                          padding: EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            controller: _transValue,
                                            validator: (value) => value.isEmpty
                                                ? "Must be filled"
                                                : null,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Value",
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                                height: 1.5,
                                              ),
                                              prefixIcon: Icon(
                                                Icons.monetization_on_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 1),
                                    Container(
                                      margin: EdgeInsets.only(top: 30),
                                      height: 45,
                                      child: InkWell(
                                        onTap: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            await pr.show();
                                            await gasConvert();
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
                                              Radius.circular(10),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.save,
                                                color: Colors.white,
                                                size: 19,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Save",
                                                style: TextStyle(
                                                  fontSize: 19,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Text(
                                  "Asset is empty",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
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
