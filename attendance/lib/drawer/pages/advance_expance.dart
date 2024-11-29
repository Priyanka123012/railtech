import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Advanceexpence extends StatefulWidget {
  const Advanceexpence({super.key});

  @override
  State<Advanceexpence> createState() => _AdvanceexpenceState();
}

class _AdvanceexpenceState extends State<Advanceexpence> {
  String? _selectedMachine;
  final TextEditingController _startDateController = TextEditingController();
  String? _paymentMode;
  final List<String> _machines = ['FBM 1', 'FBM 2', 'FBM 3'];
  final List<String> _projects = ['Project A', 'Project B', 'Project C'];
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
          'Advances',
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ).gradientBackground(withActions: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Choose One',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: _selectedMachine,
                items: _machines.map((String machine) {
                  return DropdownMenuItem<String>(
                    value: machine,
                    child: Text(machine),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedMachine = newValue;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _startDateController,
                readOnly: true, // Prevent manual input
                decoration: InputDecoration(
                  labelText: "Start Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () => _selectDate(context, _startDateController),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: _paymentMode,
                items: _projects.map((String project) {
                  return DropdownMenuItem<String>(
                    value: project,
                    child: Text(project),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _paymentMode = newValue;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                // controller: _inSituWeldController,
                decoration: InputDecoration(
                  labelText: "Balance Available",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                // controller: _inSituWeldController,
                decoration: InputDecoration(
                  labelText: "Advance Amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                // controller: _inSituWeldController,
                decoration: InputDecoration(
                  labelText: "Remark",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the "View" action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  foregroundColor: Colors.white,
                ),
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
