import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewMaterial extends StatelessWidget {
  const ViewMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data to populate the cards
    final List<Map<String, String>> _materialData = [
      {
        'sn': '1',
        'date': '01/09/2024',
        'material': 'Material A',
        'unit': 'Unit X',
        'qty': '100',
        'type': 'Type 1',
        'remark': 'No remarks',
        'attachment': 'attachment1.pdf',
      },
      {
        'sn': '2',
        'date': '02/09/2024',
        'material': 'Material B',
        'unit': 'Unit Y',
        'qty': '150',
        'type': 'Type 2',
        'remark': 'No remarks',
        'attachment': 'attachment2.pdf',
      },
      // Add more rows as needed
    ];

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
          'View Material',
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ).gradientBackground(withActions: true),
      body: ListView.builder(
        itemCount: _materialData.length,
        itemBuilder: (context, index) {
          final material = _materialData[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
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
                      children: [
                        Text(
                          'S.N.: ',
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(material['sn']!),
                        Spacer(),
                        Text(
                          'DPR Date: ',
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(material['date']!),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Material: ',
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(material['material']!),
                        SizedBox(
                          width: 76,
                        ),
                        Text(
                          'Unit Name: ',
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(material['unit']!),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Material Type: ',
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(material['type']!),
                        SizedBox(
                          width: 65,
                        ),
                        Text(
                          'Qty: ',
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(material['qty']!),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Remark: ',
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(material['remark']!),
                      ],
                    ),
                    // SizedBox(height: 0,),
                    Row(
                      children: [
                        Text(
                          'Attachment: ',
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(material['attachment']!),
                        IconButton(
                          icon: Icon(Icons.attach_file),
                          onPressed: () {
                            // Handle attachment tap
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
