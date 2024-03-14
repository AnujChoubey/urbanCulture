import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:urban_culture/styles/app_color_helper.dart';
import 'package:urban_culture/styles/text_theme_helper.dart';

import '../globals.dart';
final List<ChartData> chartData = [
  ChartData(2010, 35),
  ChartData(2011, 13),
  ChartData(2012, 34),
  ChartData(2013, 27),
  ChartData(2014, 40)
];
class StreaksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            'Today\'s Goal: ${streak + 1} streak days',
            style: TextThemeHelper.black_22_700,
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColorHelper.boxColor),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Streak Days',style: TextThemeHelper.black_16_500,),
                    SizedBox(height: 10,),
                    Text('$streak',style: TextThemeHelper.black_24_700,)
                  ],
                ),
              ],
            ),
          ),
          Center(
              child: Container(
                  child: SfCartesianChart(
                      series: <CartesianSeries>[
                        SplineSeries<ChartData, int>(
                            dataSource: chartData,
                            // Type of spline
                            splineType: SplineType.cardinal,
                            cardinalSplineTension: 0.9,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y
                        )
                      ]
                  )
              )
          )
        ],
      ),
    );
  }
}
class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}