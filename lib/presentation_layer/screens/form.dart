import 'package:event_master_web/data_layer/category_bloc/vendor_category_bloc.dart';
import 'package:event_master_web/data_layer/services/database.dart';
import 'package:event_master_web/presentation_layer/components/pushable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:random_string/random_string.dart';

class AddeTemplateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? selectedClient;
    TextEditingController categoryNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> dropdownItems = [
      {
        'value': 'Entrepreneur',
        'text': 'Entrepreneur',
        'icon': Icons.business_center,
      },
      {
        'value': 'Client',
        'text': 'Client',
        'icon': Icons.person,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 46),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Get started by adding a new template \nFor Your Clients",
                      style: TextStyle(fontSize: screenHeight * 0.06),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedClient,
                      decoration: InputDecoration(
                        labelText: 'Select Someone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: dropdownItems.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['value'],
                          child: Row(
                            children: [
                              Icon(item['icon']),
                              SizedBox(width: 8),
                              Text(item['text']),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        selectedClient = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Type a Category Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.list_alt),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 40),
                    BlocBuilder<VendorCategoryBloc, VendorCategoryState>(
                      builder: (context, state) {
                        if (state is ImagePickerLoading) {
                          return CircularProgressIndicator();
                        } else if (state is ImageSelected) {
                          return Column(
                            children: [
                              Image.memory(
                                state.imageBytes,
                                fit: BoxFit.contain,
                                width: screenWidth * 0.3,
                                height: screenHeight * 0.3,
                              ),
                              SizedBox(height: 10),
                              // Text('File name: ${state.imageName}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('File name: ${state.imageName}'),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<VendorCategoryBloc>()
                                          .add(PickImageEvent());
                                    },
                                    style: ButtonStyle(
                                      side: WidgetStateProperty.all<BorderSide>(
                                        BorderSide(
                                            color: Colors.teal, width: 2.0),
                                      ),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Change Image',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else if (state is ImagePickerError) {
                          return Text(
                            state.message,
                            style: TextStyle(color: Colors.red),
                          );
                        }
                        return Container(
                          width: screenWidth * 0.3,
                          height: screenHeight * 0.3,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                context
                                    .read<VendorCategoryBloc>()
                                    .add(PickImageEvent());
                              },
                              child: Text(
                                'Add Image\n+',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40),
                    pushableButton_Widget(
                        onPressed: () async {
                          String id = randomAlphaNumeric(10);
                          Map<String, dynamic> categoryFields = {
                            'value': selectedClient,
                            'categoryName': categoryNameController.text,
                            'description': descriptionController.text,
                          };
                          // Getting the image path from state
                          String imagePath = (context
                                  .read<VendorCategoryBloc>()
                                  .state as ImageSelected)
                              .imageName;
                          await DatabaseMethods()
                              .addCategoryDetail(
                            categoryFields,
                            id,
                            'categories/$id/$imagePath',
                          )
                              .then((value) {
                            categoryNameController.clear();
                            descriptionController.clear();
                            selectedClient = null;
                            Fluttertoast.showToast(
                              msg:
                                  "The Category Details are added Successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          });
                        },
                        text: 'Submit'),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                    child: Lottie.asset(
                  'assets/images/Animation - 1718084333468.json',
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.5,
                  fit: BoxFit.cover,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
