import 'package:flutter/material.dart';
import 'package:library_management_system/Screens/application_screen.dart';

class BottomSheetContents extends StatefulWidget {

  BottomSheetContents({this.getIssued,this.deleteApplication});
  final VoidCallback getIssued;
  final VoidCallback deleteApplication;
  @override
  _BottomSheetContentsState createState() => _BottomSheetContentsState();
}

class _BottomSheetContentsState extends State<BottomSheetContents> {


  List<Widget> bottomSheetItems = [];
  void bottomSheetPhaseOne() {
    bottomSheetItems = [];
    setState(() {
      bottomSheetItems.add(FlatButton(onPressed: bottomSheetPhaseTwo, child: Text('Accept'),),);
      bottomSheetItems.add(FlatButton(onPressed: widget.deleteApplication, child: Text('Reject'),),);
    });
  }

  void bottomSheetPhaseTwo() {
    setState(() {
      print('Phase 2 going on!');
      bottomSheetItems = [];
      bottomSheetItems.add(Text('Enter Unique Code'),);
      bottomSheetItems.add(TextField(
        onChanged: (value){
          uniqueBookCode = value;
        },
      ),);
      bottomSheetItems.add(Text('Enter Due Date in yyyy-mm-dd'),);
      bottomSheetItems.add(TextField(
        onChanged: (value){
          date = value;
        },
      ),);
      bottomSheetItems.add(FlatButton(onPressed: widget.getIssued, child: Text('Accept'),),);
    });

  }

  @override
  void initState() {
    super.initState();
    bottomSheetPhaseOne();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: bottomSheetItems,
      ),
    );
  }
}

