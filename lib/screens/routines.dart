import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_culture/styles/app_color_helper.dart';
import 'package:urban_culture/styles/text_theme_helper.dart';
import 'dart:convert';

import '../globals.dart';

class RoutineScreenParent extends StatefulWidget {
  @override
  _RoutineScreenParentState createState() => _RoutineScreenParentState();
}

class _RoutineScreenParentState extends State<RoutineScreenParent> {
  // Map to hold the state of the step data
  Global globalVar = Global();
  late Map<String, Map<String, dynamic>> data = {};

  Future<void> _saveProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('products', jsonEncode(data));
  }

  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final productsString = prefs.getString('products');
    final lastUpdateDate = prefs.getString('lastUpdateDate');
    final currentDate = DateTime.now().toIso8601String().substring(0, 10); // Get current date in yyyy-MM-dd format

    if (productsString != null && lastUpdateDate == currentDate) {
      // Use cached products data if available and it's the same day as the last update
      setState(() {
        data = Map<String, Map<String, dynamic>>.from(
          (jsonDecode(productsString) as Map).map(
                (key, value) => MapEntry(
              key.toString(),
              (value as Map).cast<String, dynamic>(),
            ),
          ),
        );
      });
    } else {
      // If no cached products data or it's a new day, use the initial data from the global file
      setState(() {
        data = Map<String, Map<String, dynamic>>.from(products);
      });

      // Save the initial data to shared preferences with the current date as the last update date
      _saveProducts();
      prefs.setString('lastUpdateDate', currentDate);
    }
  }

  @override
  initState() {
    _loadProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFCF7FA),
      body: data != null
          ? RoutineScreen(products: data, updateStepData: updateStepData)
          : Center(child: CircularProgressIndicator()),
    );
  }

  // Function to update step data
  void updateStepData(String productName, String status, String uploadTime) {
    setState(() {
      data[productName]!['status'] = status;
      data[productName]!['uploadTime'] = uploadTime;
    });
    _saveProducts();
  }
}

class RoutineScreen extends StatefulWidget {
  final Map<String, Map<String, dynamic>>? products;
  final Function(String, String, String)? updateStepData;

  RoutineScreen({this.products, this.updateStepData});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.products!.length,
          itemBuilder: (ctx, index) {
            final data = widget.products!.entries.toList();
            final title = data[index].key;
            final subtitle = data[index].value['name'];
            final status = data[index].value['status'];
            final uploadTime = data[index].value['uploadTime'];

            return _commonTile(index, title, subtitle, status, uploadTime);
          },
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Just tap to upload your image and complete the step!!',style: TextThemeHelper.appColor_14_400.copyWith(fontWeight: FontWeight.w700,fontSize: 18),),
        )
      ],
    );
  }

  Future<void> uploadImage(String productName, int index) async {
    var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      var uploadTime = await _uploadImageToFirebase(productName, pickedImage);
      widget.updateStepData!(productName, 'complete', uploadTime);
    }
  }

  Future<String> _uploadImageToFirebase(String productName, pickedImage) async {
    Global().loader(context, 3);
    var reference =
        _storage.ref().child('images/${DateTime.now()}-$productName.png');
    var uploadTask = reference.putFile(File(pickedImage.path));
    var snapshot = await uploadTask;
    var downloadURL = await snapshot.ref.getDownloadURL();
    print(
        'Image uploaded successfully for $productName. Download URL: $downloadURL');

    return DateFormat('h:mm a').format(DateTime.now());
  }

  _commonTile(index, title, subtitle, status, uploadTime) {
    return GestureDetector(
      onTap: () async {
        // Trigger image upload when tile is tapped

        HapticFeedback.vibrate();
        status!= 'complete'?uploadImage(title, index): ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColorHelper.appColor,
            content: Text('No Need! Step Already completed'),
          ),
        );

        // Update the UI with the new upload time
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 16),
              height: 48,
              width: 48,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColorHelper.boxColor,
              ),
              child: status == 'complete'
                  ? Icon(
                      Icons.done,
                      color: AppColorHelper.black,
                    )
                  : Icon(
                      Icons.star,
                      color: AppColorHelper.black,
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextThemeHelper.black_16_500,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.49,
                  child: Text(
                    subtitle,
                    style: TextThemeHelper.appColor_14_400,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Spacer(),
            Image.asset(
              'assets/images/camera_image.png',
              height: 27,
              width: 27,
            ),
            SizedBox(width: 3),
            Text(
              uploadTime ?? '',
              style: TextThemeHelper.appColor_14_400,
            ),
          ],
        ),
      ),
    );
  }
}
