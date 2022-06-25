import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/controllers/sub_asset_controller.dart';
import 'package:adr_finance_app/services/data.dart';
import 'package:adr_finance_app/util/color_icon_util.dart';
import 'package:adr_finance_app/util/dialog_confirm.dart';
import 'package:adr_finance_app/util/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'form_asset.dart';

class AssetPage extends StatefulWidget {
  @override
  _AssetPageState createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  int selectedButton = 0;
  Data data = Data();
  final SubAssetController subAssetController = Get.put(SubAssetController());
  String _selectedAsset = "0";
  BuildContext cntx;
  DialogConfirm dialogConfirm = DialogConfirm();

  @override
  void initState() {
    // TODO: implement initState
    subAssetController.refresh();
    super.initState();
  }

  void setSelectedAsset(String val) {
    List res = val.split("="); // 0 tipe, 1 Id
    _selectedAsset = res[1].toString();
    if (res[0] == "EDIT") {
      editAsset(res[1]);
    } else {
      showDeleteDialog(context, "Delete this asset data?");
    }
  }

  void editAsset(String val) async {
    String res = await Get.to(FormAsset(), arguments: [val]);
    if (res != "isBack") {
      subAssetController.refresh();
    }
  }

  void deleteAsset() async {
    Map creds = {
      'sub_id': _selectedAsset.toString(),
    };
    Map<String, dynamic> res = await data.deleteAsset(creds: creds);
    print(res);
    if (res['status']) {
      subAssetController.refresh();
    }
  }

  void showDeleteDialog(BuildContext context, String msg) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(
          primary: Colors.white54, onPrimary: Colors.black26, elevation: 1),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Yes"),
      onPressed: () {
        Get.back();
        deleteAsset();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text(msg),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    cntx = context;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20),
          // color: Pallete.greenTheme1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Pallete.linerUp1, Pallete.greenTheme2],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 75),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      String res = await Get.to<String>(
                        () => FormAsset(),
                        transition: Transition.upToDown,
                      );
                      if (res != "isBack") {
                        subAssetController.refresh();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white, // text
                      primary: Colors.white.withOpacity(0.2),
                      padding: EdgeInsets.all(10),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25),
                      ),
                      side: BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    icon: Icon(
                      Icons.add_circle_outline,
                    ),
                    label: Text("New Asset"),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 190,
          height: MediaQuery.of(context).size.height - 170,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 30, right: 20, left: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Distributed Assets",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: MediaQuery.of(context).size.height - 250,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Pallete.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                                hintText: "Search",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: MediaQuery.of(context).size.width,
                            child: Obx(() {
                              if (subAssetController.isLoading.value) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                if (subAssetController.subAssetList.length <=
                                    0) {
                                  return Center(
                                    child: Image(
                                      image: AssetImage("images/nodata1.png"),
                                      width: 200,
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  padding: EdgeInsets.only(top: 1),
                                  itemCount:
                                      subAssetController.subAssetList.length,
                                  itemBuilder: (context, index) {
                                    var _subAsset =
                                        subAssetController.subAssetList[index];
                                    return buildAssetCard(
                                        _subAsset['sub_id'].toString(),
                                        ColorIconUtil.getIcon(
                                            _subAsset['asset_icon']),
                                        _subAsset['asset_name'],
                                        _subAsset['sub_name'],
                                        _subAsset['sub_vendor'],
                                        int.parse(
                                            _subAsset['sub_value'].toString()),
                                        ColorIconUtil.getColor(
                                            _subAsset['asset_color']));
                                  },
                                );
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container buildAssetCard(String idSub, IconData icon, String type,
      String assetName, String vendor, int amount, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey[500]),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(27),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type + " (" + assetName + ")",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      SizedBox(width: 2),
                      Text(
                        vendor,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          Tools.currency(amount),
                          style: TextStyle(
                              fontSize: 15, color: Pallete.greenTheme1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          PopupMenuButton(
            child: Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            color: Pallete.greenTheme2,
            onSelected: setSelectedAsset,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "EDIT=" + idSub,
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: "DELETE=" + idSub,
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Container buildRecentContact(String name, String url) {
  //   return Container(
  //     margin: EdgeInsets.only(right: 25),
  //     child: Column(
  //       children: [
  //         Container(
  //           width: 60,
  //           height: 60,
  //           decoration: BoxDecoration(
  //             border: Border.all(width: 2, color: Colors.green),
  //             borderRadius: BorderRadius.circular(30),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(3),
  //             child: CircleAvatar(
  //               backgroundImage: NetworkImage(url),
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 5),
  //         Text(
  //           name,
  //           style: TextStyle(
  //               fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  GestureDetector buildExpanseButton(IconData icon, String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedButton = index;
        });
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: index == selectedButton
              ? Colors.white
              : Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  index == selectedButton ? Pallete.greenTheme1 : Colors.white,
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: index == selectedButton
                      ? Pallete.greenTheme1
                      : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
