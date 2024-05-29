import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../models/CategoryDTO.dart';
import '../../models/CategoryDTOListResponse.dart';
import '../../service/ApiService.dart';
import '../../service/constants.dart';

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({Key? key}) : super(key: key);

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  final controller = MultiImagePickerController(
      maxImages: 3,
      allowedImageTypes: ['png', 'jpg', 'jpeg', 'heic', 'HEIC'],
      withData: true,
      withReadStream: true,
      images: <ImageFile>[] // array of pre/default selected images
      );
  late File selectedImage;
  String _base64Image = "-1";

  TextEditingController contentcontroller = TextEditingController();
  List<CategoryDTO> categories = [];
  CategoryDTO _selectedValue = CategoryDTO();

  void fetchCategories() async {
    try {
      CategoryDTOListResponse response = await apiService.getCategories();
      print(response);
      setState(() {
        categories.clear();
        categories.addAll(response.data);
        _selectedValue = categories.first;
      });
    } catch (e) {}
  }

  final ApiService apiService = ApiService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void saveBook() async {
    List<int> imageIds = [];
    for (var element in controller.images) {
      int imgid = await apiService.uploadImage(element);
      imageIds.add(imgid);
    }

    Map<String, dynamic> request = {
      "content": contentcontroller.text,
      "category": _selectedValue.id,
      "documentIds": imageIds,
    };
    print(request);
    print(request.toString());
    print(imageIds.length);
    String result = await apiService.sharePost(request);
    if (result == "ok") {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Success!",
          textAlign: TextAlign.left,
        ),
      );
      Navigator.pop(context, "s");
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Unexpected error.",
          textAlign: TextAlign.left,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    fetchCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Constants.mainBlueColor,
          title: Text(
            'Share Post',
            style: TextStyle(color: Constants.whiteColor),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Constants.whiteColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                  colorScheme:
                      ColorScheme.light(primary: Constants.mainBlueColor)),
              child: Stepper(
                physics: ClampingScrollPhysics(),
                onStepTapped: (step) => setState(() => currentStep = step),
                type: StepperType.vertical,
                steps: getsteps(),
                currentStep: currentStep,
                onStepContinue: () {
                  final isLastStep = currentStep == getsteps().length - 1;
                  if (isLastStep) {
                    saveBook();
                  } else {
                    setState(() {
                      currentStep++;
                    });
                  }
                },
                onStepCancel: () {
                  final isFirstStep = currentStep == 0;
                  if (isFirstStep) {
                    showAlertDialog(context);
                  } else {
                    setState(() {
                      currentStep -= 1;
                    });
                  }
                },
                controlsBuilder:
                    (BuildContext context, ControlsDetails controls) {
                  return Container(
                      margin: EdgeInsets.only(top: 1),
                      child: Row(
                        children: [
                          if (currentStep == 0)
                            Expanded(
                              child: ElevatedButton(
                                child: Text("Cancel"),
                                onPressed: controls.onStepCancel,
                              ),
                            )
                          else
                            Expanded(
                              child: ElevatedButton(
                                child: Text("Back"),
                                onPressed: controls.onStepCancel,
                              ),
                            ),
                          const SizedBox(
                            width: 12,
                          ),
                          if (currentStep != getsteps().length - 1)
                            Expanded(
                              child: ElevatedButton(
                                child: Text("Continue"),
                                onPressed: controls.onStepContinue,
                              ),
                            )
                          else
                            Expanded(
                              child: ElevatedButton(
                                child: Text("Save"),
                                onPressed: controls.onStepContinue,
                              ),
                            ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ));
                },
              ),
            ),
          ],
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Continue the process"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Exit"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
          "You will lose the information you entered on the screen. Do you want to exit the process?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List<Step> getsteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text("Content"),
            content: Column(children: <Widget>[
              TextField(
                controller: contentcontroller,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 5,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Constants.mainDarkColor,
                ),
                decoration: InputDecoration(
                  disabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                        BorderSide(color: Constants.mainDarkColor, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                        BorderSide(color: Constants.mainDarkColor, width: 1),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                        BorderSide(color: Constants.mainDarkColor, width: 1),
                  ),
                  labelText: "Content",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Constants.mainDarkColor,
                  ),
                  filled: true,
                  fillColor: Color(0x00ffffff),
                  isDense: false,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  prefixIcon: Icon(Icons.numbers,
                      color: Constants.mainDarkColor, size: 18),
                ),
              ),
            ])), //ISBN

        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text("Category"),
            content: Column(children: <Widget>[
              DropdownButtonFormField<CategoryDTO>(
                value: _selectedValue,
                items: categories.map((CategoryDTO value) {
                  return DropdownMenuItem<CategoryDTO>(
                    value: value,
                    child: Text(
                      "${value.name} ",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Constants.mainDarkColor,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (CategoryDTO? newValue) {
                  setState(() {
                    _selectedValue = newValue!;
                  });
                },
                decoration: InputDecoration(
                  disabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: Constants.mainDarkColor,
                      width: 1,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: Constants.mainDarkColor,
                      width: 1,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: Constants.mainDarkColor,
                      width: 1,
                    ),
                  ),
                  labelText: "Please select a category",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Constants.mainDarkColor,
                  ),
                  filled: true,
                  fillColor: Color(0x00ffffff),
                  isDense: false,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Constants.mainDarkColor,
                    size: 18,
                  ),
                ),
              ),
            ])), // Shelf, Image

        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: Text("Image"),
            content: Column(children: <Widget>[
              MultiImagePickerView(
                controller: controller,
                padding: const EdgeInsets.all(10),
              ),
            ]))
      ];
}

void dissmissed() {}
