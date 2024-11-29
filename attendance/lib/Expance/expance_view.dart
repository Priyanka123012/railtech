import 'dart:convert';
import 'package:faecauth/Expance/get_expance_list.dart';
import 'package:faecauth/Expance/models/expance_type_model.dart';
import 'package:faecauth/Expance/models/manager_card_model.dart';
import 'package:faecauth/extension/string_ext.dart';
import 'package:faecauth/screens/home_page_screen.dart';
import 'package:http/http.dart' as http;
import 'package:faecauth/Expance/dpr_model.dart';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpancesSubmitScreens extends StatefulWidget {
  const ExpancesSubmitScreens({super.key});

  @override
  State<ExpancesSubmitScreens> createState() => _ExpancesSubmitScreensState();
}

class _ExpancesSubmitScreensState extends State<ExpancesSubmitScreens> {
  List<ExpanceCategory> expensioncategory = [];

  final TextEditingController dateFromController = TextEditingController();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  Future<String?> getManagerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('managerId');
  }

  List<ExpanceCategory> _categories = [];
  String? selectmathod;
  String? selectnameofExpance;

  List<ExpanceType> expanceTypeList = [];

  List<TDS> managerCardAssignList = [];
  String? selectmanagerCardAssign;
  String? meCategoryvalue;
  String? meCategoryId;
  String? mECTypevalue;
  String? mECTypeId;

  TextEditingController _controller = TextEditingController();
  int _value = 0;

  @override
  void initState() {
    super.initState();
    getActiveProjectName();
    fetchExpanceCategories();
    getManagerId().then(
      (managerId) {
        if (managerId != null) {
          getManagerCardAssign(managerId).then((value) {
            if (value != null) {
              setState(() {
                managerCardAssignList = value.tDS ?? [];
              });
            }
          });
        }
      },
    );
    getManagerId().then((managerId) {
      if (managerId != null) {
        getActiveProjectName();
        getManagerCardAssign(managerId).then((value) {
          if (value != null) {
            setState(() {
              managerCardAssignList = value.tDS ?? [];
            });
          }
        });
      }
    });
  }

  Future<void> fetchExpanceCategories() async {
    final url =
        Uri.parse('http://rapi.railtech.co.in/api/Expanse/getExpanseCategory');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        ExpanceCategoryModel model =
            ExpanceCategoryModel.fromJson(jsonResponse);

        setState(() {
          _categories = model.tDS ?? [];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<ExpanceType>
  //      getExpanseType(String mECategoryId) async {
  //   final url =
  //       Uri.parse('http://rapi.railtech.co.in/api/Expanse/getExpanseType');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //       "MECategoryId": mECategoryId
  //     }),
  //     );

  //     if (response.statusCode ==
  //       200) {
  //     return ExpanceType.fromJson(jsonDecode(response.body));
  //   }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> fetchExpanceType(String mECategoryId) async {
    final response = await http.post(
      Uri.parse('http://rapi.railtech.co.in/api/Expanse/getExpanseType'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'MECategoryId': mECategoryId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> tds = data['TDS'];

      setState(() {
        expanceTypeList = tds
            .map((item) => ExpanceType(
                  typeHead: item['TypeHead'],
                  mECategoryId: item['MECTypeId'],
                ))
            .toList();
      });
    } else {
      print('Failed to load categories');
    }
  }

  String cardbalance = "";

  Future<void> fetchCardBalance(String cardId) async {
    final url =
        Uri.parse('http://rapi.railtech.co.in/api/Expanse/getCardBalance');
    final requestBody = {"CardId": cardId, "CardNumber": null};

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 1) {
          String cardBalance = data['TDS'][0]['CardBalanceAvailable'];
          setState(() {
            cardbalance = cardBalance;
          });
          print('Card Balance Available: $cardBalance');
        } else {
          print('Error: ${data['statusText']}');
        }
      } else {
        print(
            'Failed to fetch card balance. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  String? cashbalance;

  Future<void> fetchCashBalance() async {
    String? managerId = await getManagerId();
    final url =
        Uri.parse('http://rapi.railtech.co.in/api/Expanse/getMemberBalance');
    final requestBody = {"ManagerId": managerId, "PaymentMode": "CASH"};

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['StatusCode'] == 1) {
          String cardBalance = data['TDS']['CashAvailable'];
          setState(() {
            cashbalance = cardBalance;
          });
          print('Cash Balance Available: $cashbalance');
        } else {
          print('Error: ${data['statusText']}');
        }
      } else {
        print(
            'Failed to fetch cash balance. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  String? activeProjectName;
  String? projectId;

  Future<void> getActiveProjectName() async {
    String? managerId = await getManagerId();
    final response = await http.post(
      Uri.parse('http://rapi.railtech.co.in/api/Expanse/getActiveProjectName'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ManagerId': managerId,
        'PaymentMode': null,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['StatusCode'] == 0) {
        setState(() {
          activeProjectName = data['TDS']['ActiveProject'];
          projectId = data['TDS']['ProjectId'];
        });
        print('Active Project: $activeProjectName');
        print('Project ID: $projectId');
      } else {
        print('Failed to get active project name: ${data['statusText']}');
      }
    } else {
      print('Error fetching project data: ${response.statusCode}');
    }
  }

  String? selectedCardId;

  Future<ManagerCardAssignModel?> getManagerCardAssign(String managerId) async {
    final response = await http.post(
      Uri.parse('http://rapi.railtech.co.in/api/Expanse/getManagerCardAssign'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"ManagerId": managerId, "PaymentMode": null}),
    );

    if (response.statusCode == 200) {
      ManagerCardAssignModel data = ManagerCardAssignModel();
      setState(() {
        managerCardAssignList = data.tDS ?? [];
      });
      return ManagerCardAssignModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  TextEditingController remarkctrl = TextEditingController();

  Future<void> addSiteExpanse() async {
    String? managerId = await getManagerId();

    String? empId = await getEmpBasicDetailId();
    final url =
        Uri.parse('http://rapi.railtech.co.in/api/Expanse/AddSiteExpanse');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "ManagerId": managerId,
          "ProjectId": projectId,
          "ProjectType": null,
          "Type": null,
          "Mode": selectmathod,
          "Reference": null,
          "SubmitDate": dateFromController.text,
          "MECategoryId": meCategoryId,
          "NameOfExpance": meCategoryvalue,
          "MECTypeId": mECTypeId,
          "ExpanseType": mECTypevalue,
          "Discription": remarkctrl.text.toString(),
          "Attachment": "",
          "Amount": _value,
          "CardId": selectedCardId,
          "WithdrawalAttachment": "",
          "AvailableBalance":
              selectmathod == "Card" ? cardbalance : cashbalance,
          "UserId": empId
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse["StatusCode"] == 1) {
          "${jsonResponse["statusText"]}".showToast(duration: 10);
          Get.offAll(() => HomePageScreeen());
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageScreeen()));
        }
      }
    } catch (e) {
      print("Errorr${e}");
    }
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _imageFiles.add(selectedImage);
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles.addAll(selectedImages);
      });
    }
  }

  void _increment() {
    setState(() {
      _value++;
      _controller.text = _value.toString();
    });
  }

  void _decrement() {
    setState(() {
      if (_value > 0) {
        _value--;
        _controller.text = _value.toString();
      }
    });
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickMultipleImages();
                    }),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Submit Expance',
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Get.to(() => ExpenseListScreen());
        //       },
        //       icon: Icon(Icons.list))
        // ],
      ).gradientBackground(withActions: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                // controller: dateFromController,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText:
                      activeProjectName != null ? "$activeProjectName" : "",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 10),
              CustomDropdown(
                items: ["Card", "Cash"],
                hint: 'Select Payment Method',
                onChanged: (String? newValue) {
                  setState(() {
                    selectmathod = newValue;
                    if (selectmathod == "Cash") {
                      fetchCashBalance();
                    }
                    print(selectmathod);
                  });
                },
              ),
              SizedBox(height: 10),
              if (selectmathod == "Card")
                CustomDropdown(
                  items: managerCardAssignList
                      .map((category) => category.cardNumber!)
                      .toList(),
                  hint: 'Assigned Card',
                  onChanged: (String? newValue) {
                    setState(() {
                      TDS? selectedCard = managerCardAssignList.firstWhere(
                        (cardData) => cardData.cardNumber == newValue,
                      );
                      selectedCardId = selectedCard.cardId;
                      selectmanagerCardAssign = newValue;
                      if (selectmanagerCardAssign != null) {
                        fetchCardBalance(selectedCardId.toString());
                      }
                      print('Selected Card Number: $newValue');
                      print('Selected Card ID: $selectedCardId');
                    });
                  },
                ),
              Visibility(
                  visible: selectmathod != null, child: SizedBox(height: 10)),
              Visibility(
                visible: selectmathod != null,
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: selectmathod != "Cash"
                          ? "  \u{20B9}${cardbalance}"
                          : " \u{20B9}${cashbalance}",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                      border: OutlineInputBorder()),
                ),
              ),
              Visibility(
                  visible: selectmathod != null, child: SizedBox(height: 10)),
              TextFormField(
                controller: dateFromController,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: "Date From",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  suffixIcon: Icon(
                    Icons.calendar_month,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onTap: () {
                  _selectDate(context, dateFromController);
                },
              ),
              SizedBox(height: 10),
              // CustomDropdown(
              //   items: _categories.map((category) => category.catHead!).toList(),
              //   hint: 'Type of Expance',
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       _selectedCategory = newValue;
              //       print(_selectedCategory);
              //     });
              //   },
              // ),

              CustomDropdown(
                items:
                    _categories.map((category) => category.catHead!).toList(),
                hint: 'Expance Category*',
                onChanged: (String? newValue) {
                  setState(() {
                    ExpanceCategory? selectedCard = _categories.firstWhere(
                      (cardData) => cardData.catHead == newValue,
                    );
                    meCategoryId = selectedCard.mECategoryId;
                    meCategoryvalue = newValue;
                    if (meCategoryvalue != null) {
                      fetchExpanceType(meCategoryId.toString());
                    }
                  });
                },
              ),
              SizedBox(height: 10),
              CustomDropdown(
                items: expanceTypeList
                    .map((category) => category.typeHead)
                    .toList(),
                hint: 'Expance Type*',
                onChanged: (String? newValue) {
                  setState(() {
                    ExpanceType? selectedCard = expanceTypeList.firstWhere(
                      (cardData) => cardData.typeHead == newValue,
                    );
                    mECTypeId = selectedCard.mECategoryId;
                    mECTypevalue = newValue;
                  });
                },
              ),
              // SizedBox(height: 10),
              // CustomDropdown(
              //   items: [],
              //   hint: 'Name of Expance*',
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       selectnameofExpance = newValue;
              //       print(selectnameofExpance);
              //     });
              //   },
              // ),
              SizedBox(height: 10),
              TextFormField(
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
                  hintText: "Expance Value*",
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
              SizedBox(height: 10),
              TextFormField(
                // textAlign: TextAlign.start,
                controller: remarkctrl,
                decoration: InputDecoration(
                  hintText: "Discriptions",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                maxLines: 4,
              ),
              // SizedBox(height: 10),
              // Row(
              //   children: [
              //     Text(
              //       "ATTACHMENT",
              //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              //     ),
              //     Spacer(),
              //     Padding(
              //       padding: const EdgeInsets.only(right: 0),
              //       child: Container(
              //         width: Get.width * 0.6,
              //         color: Colors.green.shade700,
              //         child: Row(
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.symmetric(vertical: 3),
              //               child: InkWell(
              //                 onTap: () {
              //                   _showPickerOptions(context);
              //                 },
              //                 child: Card(
              //                   shape: RoundedRectangleBorder(),
              //                   child: Padding(
              //                     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              //                     child: Text(
              //                       "Choose File",
              //                       style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Container(
              //               width: Get.width * 0.3,
              //               height: 45,
              //               child: Center(
              //                 child: Text(
              //                   textAlign: TextAlign.center,
              //                   _imageFiles.isEmpty ? "No File Choosen" : _imageFiles.first.path,
              //                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),

              //   ],
              // ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: InkWell(
                  onTap: () async {
                    await addSiteExpanse();
                  },
                  child: Container(
                    width: Get.width,
                    height: 55,
                    child: Card(
                      color: Colors.teal.shade200,
                      shape: RoundedRectangleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  CustomDropdown({
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isDropdownOpen = false;
  String? _selectedItem;

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _selectItem(String item) {
    setState(() {
      _selectedItem = item;
      _isDropdownOpen = false;
    });
    widget.onChanged(item);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedItem ?? widget.hint,
                  style: TextStyle(
                      color:
                          _selectedItem == null ? Colors.grey : Colors.black),
                ),
                Icon(
                  _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
        if (_isDropdownOpen)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 150,
            ),
            child: Container(
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Scrollbar(
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: widget.items.map((item) {
                    return GestureDetector(
                      onTap: () => _selectItem(item),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(item),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
