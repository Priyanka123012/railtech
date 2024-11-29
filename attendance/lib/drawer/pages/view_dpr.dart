import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Viewdpr extends StatefulWidget {
  const Viewdpr({super.key});

  @override
  _ViewdprState createState() => _ViewdprState();
}

class _ViewdprState extends State<Viewdpr> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  DateTime _startDate =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime _endDate =
      DateTime.now().add(Duration(days: 7 - DateTime.now().weekday));

  // Add variables for dropdowns
  String? _selectedMachine;
  String? _selectedProject;

  // Example lists for machines and projects
  final List<String> _machines = ['FBM 1', 'FBM 2', 'FBM 3'];
  final List<String> _projects = ['Project A', 'Project B', 'Project C'];

  // Example data for the DataTable
  List<List<String>> _dprData = [
    // Each row must have exactly 37 elements
    // Make sure to add or remove elements to match the number of columns
    List.generate(37, (index) => 'Data $index'),
    List.generate(
        37, (index) => 'Data $index'), // Sample row, add more as needed
  ];

  Future<void> _selectDate(
      TextEditingController controller, DateTime initialDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = _dateFormat.format(pickedDate);
        if (controller == _startDateController) {
          _startDate = pickedDate;
        } else if (controller == _endDateController) {
          _endDate = pickedDate;
        }
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
          'View DPR',
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),s
        ),
      ).gradientBackground(withActions: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Machine(FBM)',
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
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Project',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: _selectedProject,
                    items: _projects.map((String project) {
                      return DropdownMenuItem<String>(
                        value: project,
                        child: Text(project),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedProject = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () =>
                            _selectDate(_startDateController, _startDate),
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () =>
                            _selectDate(_endDateController, _endDate),
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Trigger the data fetching and table update
                setState(() {
                  // For now, we just refresh the table with sample data
                  _dprData = [
                    List.generate(37, (index) => 'Data $index'),
                    // Add more rows here
                  ];
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade800,
                foregroundColor: Colors.white,
              ),
              child: Text("View"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('S.N.')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Zone')),
                    DataColumn(label: Text('Division')),
                    DataColumn(label: Text('Project')),
                    DataColumn(label: Text('Manager')),
                    DataColumn(label: Text('Machine (FBW)')),
                    DataColumn(label: Text('RVNO')),
                    DataColumn(label: Text('Section')),
                    DataColumn(label: Text('Serial No')),
                    DataColumn(label: Text('On CessWeld')),
                    DataColumn(label: Text('On CessWeld CUM')),
                    DataColumn(label: Text('InSituWeld')),
                    DataColumn(label: Text('InSitu Cum')),
                    DataColumn(label: Text('Daily Weld Cum')),
                    DataColumn(label: Text('Diesel Purchase FBW')),
                    DataColumn(label: Text('Diesel Purchase FBW cum')),
                    DataColumn(label: Text('Diesel Purchase Other')),
                    DataColumn(label: Text('Diesel Purchase Other CUM')),
                    DataColumn(label: Text('Petrol Purchase')),
                    DataColumn(label: Text('Petrol CUM')),
                    DataColumn(label: Text('Block Time')),
                    DataColumn(label: Text('Block Time InSitu')),
                    DataColumn(label: Text('Block Time Minute')),
                    DataColumn(label: Text('HOLE32MM')),
                    DataColumn(label: Text('HOLE32MM CUM')),
                    DataColumn(label: Text('RAILCUT')),
                    DataColumn(label: Text('RAILCUT CUM')),
                    DataColumn(label: Text('Labour Strength')),
                    DataColumn(label: Text('Labour Present')),
                    DataColumn(label: Text('Labour Present CUM')),
                    DataColumn(label: Text('Labour Absent')),
                    DataColumn(label: Text('Staff Strength')),
                    DataColumn(label: Text('Staff Present')),
                    DataColumn(label: Text('Staff Present CUM')),
                    DataColumn(label: Text('Staff Absent')),
                    DataColumn(label: Text('Remark')),
                  ],
                  rows: _dprData.map((row) {
                    if (row.length != 37) {
                      print('Row length mismatch: ${row.length}');
                    }
                    return DataRow(
                      cells: row.map((cell) => DataCell(Text(cell))).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
