import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDpr extends StatefulWidget {
  const AddDpr({super.key});

  @override
  State<AddDpr> createState() => _AddDprState();
}

class _AddDprState extends State<AddDpr> {
  String? _selectedMachine;
  String? _selectedProject;
  final TextEditingController _dprDateController = TextEditingController();
  final TextEditingController _rvNoController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _blockTimeFromController =
      TextEditingController();
  final TextEditingController _applyDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _blockTimeToController = TextEditingController();
  final TextEditingController _inSituWeldController = TextEditingController();
  final TextEditingController _onCessController = TextEditingController();
  final TextEditingController _cumController = TextEditingController();
  final TextEditingController _raicutController = TextEditingController();
  final TextEditingController _raicutcUMController = TextEditingController();
  final TextEditingController _DieaselPurchaseController =
      TextEditingController();
  final TextEditingController _dieaselOtherController = TextEditingController();
  final TextEditingController _dieselFBWController = TextEditingController();
  final TextEditingController _32MMcONTROLLER = TextEditingController();
  final TextEditingController _spclremarkController = TextEditingController();
  // final TextEditingController _inSituWeldController = TextEditingController();

  double _inSituWeldValue = 0;

  final List<String> _machines = ['FBM 1', 'FBM 2', 'FBM 3'];
  final List<String> _projects = ['Project A', 'Project B', 'Project C'];

  bool _isInSituWeldYes = true;
  bool _isInSituWeldNo = false;

  // void _incrementValue() {
  //   setState(() {
  //     _inSituWeldValue++;
  //     _inSituWeldController.text = _inSituWeldValue.toString();
  //   });
  // }

  // void _decrementValue() {
  //   setState(() {
  //     if (_inSituWeldValue > 0) {
  //       _inSituWeldValue--;
  //       _inSituWeldController.text = _inSituWeldValue.toString();
  //     }
  //   });
  // }

  TextEditingController _controller = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();
  TextEditingController _controller6 = TextEditingController();
  TextEditingController _controller7 = TextEditingController();
  TextEditingController _controller8 = TextEditingController();
  TextEditingController _controller08 = TextEditingController();
  TextEditingController _controller9 = TextEditingController();
  TextEditingController _controller10 = TextEditingController();
  TextEditingController _controller11 = TextEditingController();
  int _value = 0;
  void _increment() {
    setState(() {
      _value++;
      _controller.text = _value.toString();
      _controller1.text = _value.toString();
      _controller2.text = _value.toString();
      _controller3.text = _value.toString();
      _controller4.text = _value.toString();
      _controller5.text = _value.toString();
      _controller6.text = _value.toString();
      _controller7.text = _value.toString();
      _controller8.text = _value.toString();
      _controller08.text = _value.toString();
      _controller9.text = _value.toString();
      _controller10.text = _value.toString();
      _controller11.text = _value.toString();
    });
  }

  void _decrement() {
    setState(() {
      if (_value > 0) {
        _value--;
        _controller.text = _value.toString();
        _controller1.text = _value.toString();
        _controller2.text = _value.toString();
        _controller3.text = _value.toString();
        _controller4.text = _value.toString();
        _controller5.text = _value.toString();
        _controller6.text = _value.toString();
        _controller7.text = _value.toString();
        _controller8.text = _value.toString();
        _controller08.text = _value.toString();
        _controller9.text = _value.toString();
        _controller10.text = _value.toString();
        _controller11.text = _value.toString();
      }
    });
  }

  Future<void> _selectTime(TextEditingController controller,
      {required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        final formattedTime = pickedTime.format(context);
        controller.text = formattedTime;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(vsync: this);
    _inSituWeldController.text = _inSituWeldValue.toString();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
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
            'ADD DPR',
            // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ).gradientBackground(withActions: true),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
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
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
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
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _dprDateController,
                    decoration: InputDecoration(
                      labelText: "DPR Date",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a DPR Date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _rvNoController,
                    decoration: InputDecoration(
                      labelText: "Rv No",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _sectionController,
                    decoration: InputDecoration(
                      labelText: "Section",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "In Situ Weld",
                        // style: TextStyle(
                        //     fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isInSituWeldYes,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isInSituWeldYes = value ?? false;
                                  if (_isInSituWeldYes) {
                                    _isInSituWeldNo = false;
                                  }
                                });
                              },
                            ),
                            Text("Yes"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isInSituWeldNo,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isInSituWeldNo = value ?? false;
                                  if (_isInSituWeldNo) {
                                    _isInSituWeldYes = false;
                                  }
                                });
                              },
                            ),
                            Text("No"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (_isInSituWeldYes) ...[
                    _buildTimeField(
                      controller: _applyDateController,
                      focusNode: FocusNode(),
                      labelText: 'BlockTime From',
                      isStartTime: true,
                    ),
                    // SizedBox(height: 10),
                    _buildTimeField(
                      controller: _endTimeController,
                      focusNode: FocusNode(),
                      labelText: 'BlockTime To',
                      isStartTime: true,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            // textAlign: TextAlign.start,
                            onChanged: (value) {
                              setState(() {
                                _value = int.tryParse(value) ?? 0;
                                print("878787===${_value}");
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "In Situ Weld",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              contentPadding: EdgeInsets.all(10),
                              suffixIcon: Column(
                                children: [
                                  InkWell(
                                      onTap: _increment,
                                      child:
                                          Icon(Icons.arrow_drop_up_outlined)),
                                  InkWell(
                                      onTap: _decrement,
                                      child: Icon(Icons.arrow_drop_down_sharp)),
                                ],
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // if (Form.of(context)?.validate() ?? false) {
                            //   // Handle form submission
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("ADD"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Table(
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("SR .No"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("BlockTime From"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("BlockTime To"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("InSituWeld"),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("1"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Work 1"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Remark 1"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Attachment 1"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 20),
                  TextFormField(
                    // controller: _,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: "0",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller1,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      // hintText: "In Situ Weld",
                      hintText: "On Cess",

                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _inSituWeldController,
                    decoration: InputDecoration(
                        labelText: "On Cess CUM",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _inSituWeldController,
                    decoration: InputDecoration(
                        labelText: "Total month CUM",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller2,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "32MMHOLE",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _cumController,
                    decoration: InputDecoration(
                        labelText: "HOLE32MM CUM",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller3,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "RailCut",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _raicutcUMController,
                    decoration: InputDecoration(
                        labelText: "RAILCUT CUM",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller4,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Diesel Purchase FBW",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _dieselFBWController,
                    decoration: InputDecoration(
                        labelText: "Diesel Purchase FBW CUM",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller5,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Dieasel Purchase Other",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _dieaselOtherController,
                    decoration: InputDecoration(
                        labelText: "Diesel Purchase Other Cum",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller6,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Petrol Purchase",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Petrol Purchase CUM",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller7,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        // print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Labour",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller8,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        // print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Present",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Labour Present CUM",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Absent",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller08,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Staff",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller9,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Presnet",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Staff Present CUM",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Absent",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _controller10,
                    keyboardType: TextInputType.number,
                    // textAlign: TextAlign.start,
                    onChanged: (value) {
                      setState(() {
                        _value = int.tryParse(value) ?? 0;
                        print("878787===${_value}");
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Spcl Remark",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: Column(
                        children: [
                          InkWell(
                              onTap: _increment,
                              child: Icon(Icons.arrow_drop_up_outlined)),
                          InkWell(
                              onTap: _decrement,
                              child: Icon(Icons.arrow_drop_down_sharp)),
                        ],
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (Form.of(context)?.validate() ?? false) {
                        // Handle form submission
                      }
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
        ));
  }

  Widget _buildTimeField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required bool isStartTime,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
        onTap: () {
          focusNode.unfocus();
          _selectTime(controller, isStartTime: isStartTime);
        },
        readOnly: true,
      ),
    );
  }
}
