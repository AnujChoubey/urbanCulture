import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_culture/styles/app_color_helper.dart';
import 'package:urban_culture/styles/text_theme_helper.dart';

class RoutineScreen extends StatefulWidget {
  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final Map<String, String> products = {
    'Cleanser': 'Cetaphil Gentle Skin Cleanser',
    'Toner': 'Thayers Witch Hazel Toner',
    'Moisturizer': 'Kiehl\'s Ultra Facial Cream',
    'Sunscreen': 'Supergoop Unseen Sunscreen SPF 40',
    'Lip Balm': 'Glossier Birthday Balm Dotcom',
  };

  final List<String> times = [
    '8:00 PM',
    '8:02 PM',
    '8:04 PM',
    '8:06 PM',
    '8:08 PM'
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (ctx, index) {
              final data = products.entries.toList();
              final title = data[index].key;
              final subtitle = data[index].value;

              return _commonTile(index, title, subtitle);
            }),
      ],
    );
  }

  _commonTile(index, title, subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: GestureDetector(
        onTap: () async {
          // Trigger image upload when tile is tapped
          var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
          if (pickedImage != null) {
            // Upload image to Firebase Storage
            var reference = _storage.ref().child('images/${DateTime.now()}.png');
            var uploadTask = reference.putFile(File(pickedImage.path));

            // Monitor upload progress

            // Get download URL when upload is complete
            uploadTask.then((snapshot) {
              snapshot.ref.getDownloadURL().then((downloadURL) {
                // Do something with the download URL (e.g., store it in Firestore)
                print('Image uploaded successfully. Download URL: $downloadURL');
              });
            });
          }
        },
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 16),
              height: 48,
              width: 48,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColorHelper.boxColor),
              child: Icon(
                Icons.done,
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
                  width: MediaQuery.of(context).size.width *0.49,
                  child: Text(
                    subtitle,
                    style: TextThemeHelper.appColor_14_400,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Image.asset('assets/images/camera_image.png',height: 27,width: 27,),
                SizedBox(width: 3,),
                Text(times[index],style: TextThemeHelper.appColor_14_400,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
