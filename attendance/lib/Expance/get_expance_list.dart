import 'dart:convert';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<dynamic> expenseList = [];

  Future<String?> getManagerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('managerId');
  }

  Future<void> fetchExpenseList() async {
    String? managerId = await getManagerId();
    final url =
        Uri.parse('http://rapi.railtech.co.in/api/Expanse/getExpanseList');
    final requestBody = {"ManagerId": managerId, "PaymentMode": null};

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 1) {
          setState(() {
            expenseList = data['TDS'];
          });
          print('Expense List Fetched Successfully');
        } else {
          print('Error: ${data['statusText']}');
        }
      } else {
        print(
            'Failed to fetch expense list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchExpenseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Expance List',
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ).gradientBackground(withActions: true),
      body: expenseList.isNotEmpty
          ? ListView.builder(
              itemCount: expenseList.length,
              itemBuilder: (context, index) {
                final expense = expenseList[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      // expense['NameOfExpance'],
                      // style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      // 
                      // 
                      "",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Type  : ',
                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text('${expense['ExpanseType']}')),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Description  : ',
                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text('${expense['Discription']}')),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Amount  : ',
                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                flex: 2, child: Text('${expense['Amount']}')),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Date  : ',
                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text('${expense['SubmitDate']}')),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Reference  : ',
                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text('${expense['Reference']}')),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Mode  : ',
                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                flex: 2, child: Text('${expense['Mode']}')),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Image.asset("assets/nodataa.png"),
            ),
    );
  }
}
