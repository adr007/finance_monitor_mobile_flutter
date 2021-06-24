import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/controllers/transaction_controller.dart';
import 'package:adr_finance_app/services/data.dart';
import 'package:adr_finance_app/util/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  Data data = Data();
  final TransactionController transController = Get.put(TransactionController());
  String _selectedTrans = "0";


  Icon getStatusIcon(String tipe) {
    switch (tipe) {
      case "UP":
        return Icon(
          Icons.upload_outlined,
          color: Colors.green,
          size: 25,
        );
      case "DOWN":
        return Icon(
          Icons.download_outlined,
          color: Colors.red,
          size: 25,
        );
      default:
        return Icon(Icons.info);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transController.refresh();

  }

  void selecTrans(String idTrans) {
    print(idTrans);
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
        deleteTrans();
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

  void deleteTrans() async {
    Map creds = {
      'trans_id': _selectedTrans,
    };
    Map<String, dynamic> res = await data.deleteTransaction(creds: creds);
    // print(res);
    if (res['status']) {
      transController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Pallete.backgroundColorDarkMode,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg-anime1.jpg"),
            alignment: Alignment.topRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50, left: 17),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 170),
                  ClipPath(
                    clipper: BestSellerClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Pallete.greenTheme2,
                        Pallete.greenTheme3,
                      ])),
                      padding: EdgeInsets.only(
                          left: 10, top: 7, right: 20, bottom: 7),
                      child: Text(
                        "Newest Transactions",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 510,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
                color: Pallete.backgroundColorDarkMode,
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(() {
                      if (transController.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (transController.transList.length <= 0) {
                          return Center(
                            child: Image(
                              image: AssetImage("images/nodata1.png"),
                              width: 200,
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          itemCount: transController.transList.length,
                          itemBuilder: (context, index) {
                            var _trans = transController.transList[index];
                            return buildTransItem(
                                getStatusIcon(_trans['trans_status']),
                                int.parse(_trans['trans_value'].toString()),
                                _trans['sub_name'],
                                _trans['trans_information'],
                                _trans['trans_id'].toString());
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
    );
  }

  GestureDetector buildTransItem(
      Icon icon, int amount, String subAsset, String info, String idTrans) {
    return GestureDetector(
      onTap: () {
        _selectedTrans = idTrans;
        print(_selectedTrans);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 70,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Pallete.backgroundSoftColorDarkMode,
                      Colors.blueGrey.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  SizedBox(width: 7),
                  Container(
                    padding: EdgeInsets.only(right: 7),
                    height: 45,
                    child: icon,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(width: 1.5, color: Colors.grey[500]),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 275,
                    padding: EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  Tools.currency(amount),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "(" + subAsset + ")",
                                  style: TextStyle(
                                      color: Pallete.greenTheme3, fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(height: 3),
                            Container(
                              width: 250,
                              child: Text(
                                ": " + info,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.7),
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: (){
                  _selectedTrans = idTrans;
                  print("Delete "+_selectedTrans);
                  showDeleteDialog(context, "Delete transaction data?");
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(.3),
                        blurRadius: 2,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 15,
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



class BestSellerClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
