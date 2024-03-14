import 'package:flutter/material.dart';
import 'package:urban_culture/styles/app_color_helper.dart';


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
      });
      return Container(
        color: Colors.black.withOpacity(0.5), // Semi-transparent black color for the background
        child: Center(
          child: CircularProgressIndicator(color: AppColorHelper.appColor,), // Circular progress indicator
        ),
      );
    });
  }



}