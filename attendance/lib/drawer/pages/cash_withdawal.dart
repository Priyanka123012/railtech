import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Model class to store the withdrawal data
class WithdrawalData {
  final String date;
  final String remark;
  final String amount;
  final String attachment;

  WithdrawalData({
    required this.date,
    required this.remark,
    required this.amount,
    required this.attachment,
  });
}

class CashWithdrawal extends StatefulWidget {
  const CashWithdrawal({super.key});

  @override
  State<CashWithdrawal> createState() => _CashWithdrawalState();
}

class _CashWithdrawalState extends State<CashWithdrawal> {
  String? selectCard;

  final List<String> _card = ['FBM 1', 'FBM 2', 'FBM 3'];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _withdrawalAmount = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  int _value = 0;
  List<WithdrawalData> _submittedData = [];

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
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
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

  void _submitData() {
    setState(() {
      // Adding the form data to the submitted data list
      _submittedData.add(WithdrawalData(
        date: _startDateController.text,
        remark: _remarkController.text,
        amount: _controller.text,
        attachment: _attachmentController.text.isEmpty
            ? 'No attachment'
            : _attachmentController.text,
      ));
      _startDateController.clear();
      _remarkController.clear();
      _controller.clear();
      _attachmentController.clear();
    });
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Cash Withdrawal',
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ).gradientBackground(withActions: true),
      body: Column(
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Section
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Card',
                            contentPadding: EdgeInsets.all(6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          value: selectCard,
                          items: _card.map((String machine) {
                            return DropdownMenuItem<String>(
                              value: machine,
                              child: Text(machine),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectCard = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Amount (0.00)",
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _withdrawalAmount,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _value = int.tryParse(value) ?? 0;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Withdrawal Amount",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          contentPadding: const EdgeInsets.all(10),
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: _increment,
                                child: const Icon(Icons.arrow_drop_up),
                              ),
                              InkWell(
                                onTap: _decrement,
                                child: const Icon(Icons.arrow_drop_down),
                              ),
                            ],
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Start Date",
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onTap: () => _selectDate(context, _startDateController),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _remarkController,
                        maxLines: 3,
                        // textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          labelText: "Remark",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _attachmentController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Attachment *",
                              contentPadding: EdgeInsets.all(8),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  // Handle file attachment here
                                },
                                icon: const Icon(Icons.attach_file),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade800,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 12),
                            ),
                            child: const Text("Submit"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5)
              ],
            ),
          ),
          // Submitted Data Section
          Container(
            height: Get.height * 0.55,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(),
                    elevation: 3,
                    // margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 1, child: Text("S.N.: ")),
                              Expanded(flex: 2, child: Text("10")),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex: 1, child: Text("Date: ")),
                              Expanded(flex: 2, child: Text("10/09/2024")),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(flex: 1, child: Text("Remark: ")),
                              Expanded(flex: 2, child: Text("Hello World...")),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex: 1, child: Text("Amount : ")),
                              Expanded(flex: 2, child: Text("1000")),
                            ],
                          ),
                          // const SizedBox(height: 2),
                          // Row(
                          //   children: [
                          //     Expanded(flex: 1, child: Text("Attachment : ")),
                          //     Expanded(flex: 1, child: Text(".document.png: ")),
                          //     Expanded(
                          //       flex: 1,
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.end,
                          //         crossAxisAlignment: CrossAxisAlignment.end,
                          //         children: [
                          //           IconButton(onPressed: () {}, icon: Icon(Icons.download)),
                          //           IconButton(onPressed: () {}, icon: Icon(Icons.visibility))
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
