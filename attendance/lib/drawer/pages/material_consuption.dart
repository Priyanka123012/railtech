import 'package:faecauth/drawer/pages/material_consuption_ctrl.dart';
import 'package:faecauth/drawer/pages/view_material.dart';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Materialconsumptiom extends StatelessWidget {
  const Materialconsumptiom({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final MaterialConsumptionController controller =
        Get.put(MaterialConsumptionController());

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
          'Material Consumption',
          // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ).gradientBackground(withActions: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Date Picker Field
                Obx(() => TextFormField(
                      readOnly: true,
                      onTap: () => controller.selectDate(context),
                      decoration: InputDecoration(
                        labelText: controller.selectedDate.value == null
                            ? 'Select Date'
                            : 'Date: ${controller.selectedDate.value.toString().split(' ')[0]}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (controller.selectedDate.value == null) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    )),
                SizedBox(height: 10),

                // Material Dropdown
                Obx(() => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select Material",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: controller.selectedMaterial.value,
                      items: controller.materials
                          .map((material) => DropdownMenuItem(
                              value: material, child: Text(material)))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedMaterial.value = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a material';
                        }
                        return null;
                      },
                    )),
                SizedBox(height: 10),

                // Unit Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Unit",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a unit';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Quantity Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Remark Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Remark",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a remark';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // File Attachment Field
                Obx(() => TextFormField(
                      readOnly: true,
                      onTap: controller.pickFile,
                      decoration: InputDecoration(
                        labelText: controller.selectedFile.value == null
                            ? 'Attachment'
                            : 'File: ${controller.selectedFile.value?.path.split('/').last}',
                        suffixIcon: IconButton(
                          onPressed: controller.pickFile,
                          icon: Icon(Icons.attach_file),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (controller.selectedFile.value == null) {
                          return 'Please select a file';
                        }
                        return null;
                      },
                    )),
                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    controller.submitForm();
                    Get.to(() => ViewMaterial());
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
      ),
    );
  }
}
