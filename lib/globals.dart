import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:urban_culture/styles/app_color_helper.dart';
import 'package:urban_culture/styles/text_theme_helper.dart';


GlobalKey? globalKey;

Map<String, Map<String, dynamic>> products = {
  'Cleanser': {
    'name': 'Cetaphil Gentle Skin Cleanser',
    'status': 'incomplete', // Initially set to incomplete
    'uploadTime': '', // Initialize upload time
  },
  'Toner': {
    'name': 'Thayers Witch Hazel Toner',
    'status': 'incomplete',
    'uploadTime': '',
  },
  'Moisturizer': {
    'name': 'Kiehl\'s Ultra Facial Cream',
    'status': 'incomplete',
    'uploadTime': '',
  },
  'Sunscreen': {
    'name': 'Supergoop Unseen Sunscreen SPF 40',
    'status': 'incomplete',
    'uploadTime': '',
  },
  'Lip Balm': {
    'name': 'Glossier Birthday Balm Dotcom',
    'status': 'incomplete',
    'uploadTime': '',
  },
};
int streak = 0;

class Global{


  loader(context,seconds){
    showDialog(context: context, builder: (ctx){
      Future.delayed(Duration(seconds: seconds),(){
        Navigator.pop(ctx);
        Global().successDialog(context);
      });
      return Container(
        color: Colors.black.withOpacity(0.5), // Semi-transparent black color for the background
        child: Center(
          child: CircularProgressIndicator(color: AppColorHelper.appColor,), // Circular progress indicator
        ),
      );
    });
  }
  successDialog(context) {
    showDialog(
        context: context,
        builder: (ctx) {
          Future.delayed(Duration(seconds: 2),(){
            Navigator.pop(ctx);

          });
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(border: Border.all(color: Colors.green,width: 2),shape: BoxShape.circle),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      )).animate().scale(),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Image uploaded successfully',
                    style: TextThemeHelper.black_16_500,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          );
        });
  }


}