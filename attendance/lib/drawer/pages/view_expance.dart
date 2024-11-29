import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewExpense extends StatefulWidget {
  const ViewExpense({super.key});

  @override
  _ViewExpenseState createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Function to show DatePicker and set date in controller
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text =
            DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'VIEW TRANSACTIONS',
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ).gradientBackground(withActions: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Date Selection Row
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextFormField(
                      controller: _startDateController,
                      readOnly: true, // Prevent manual input
                      decoration: InputDecoration(
                        labelText: "Start Date",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () => _selectDate(context,
                          _startDateController), // Call date picker on tap
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: _endDateController,
                      readOnly: true, // Prevent manual input
                      decoration: InputDecoration(
                        labelText: "End Date",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () => _selectDate(context,
                          _endDateController), // Call date picker on tap
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle the "View" action here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("View"),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Expense Details Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("S.N.: 1",
                            // style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                        Text("Date: 2024-09-12",
                            // style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Text("Reference: #EXP001")),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Text("Name Of Expense: Office Rent")),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                                "Description: Monthly office rent payment")),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Text("Mode: Credit Card")),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("CREDIT: ₹30,000",
                            style: TextStyle(color: Colors.green)),
                        Text("DEBIT: ₹0", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.attachment),
                        SizedBox(width: 5),
                        Text("Attachment: office_rent_receipt.pdf"),
                      ],
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
