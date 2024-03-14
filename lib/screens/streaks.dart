import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:urban_culture/styles/app_color_helper.dart';
import 'package:urban_culture/styles/text_theme_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart';
import '../provider/streak_provider.dart';
enum ChartDataType {
  Days,
  Weeks,
  Months,
  Yearly,
}

final List<ChartData> chartData = [
  ChartData(1, 5),
  ChartData(2, 1),
  ChartData(3, 4),
  ChartData(4, 3),
  ChartData(5, 5)
];
final List<ChartData> chartData1W = [
  ChartData(1, 5),
  ChartData(2, 5),
  ChartData(3, 1),
  ChartData(4, 5),
  ChartData(5, 5)
];
final List<ChartData> chartData1M = [
  ChartData(1, 1),
  ChartData(2, 2),
  ChartData(3, 3),
  ChartData(4, 4),
  ChartData(5, 5)
];
final List<ChartData> chartData3M = [
  ChartData(1, 1),
  ChartData(2, 3),
  ChartData(3, 3),
  ChartData(4, 5),
  ChartData(5, 5)
];
final List<ChartData> chartData1Y = [
  ChartData(1, 1),
  ChartData(2, 3),
  ChartData(3, 2),
  ChartData(4, 4),
  ChartData(5, 5)
];

class StreaksScreen extends StatefulWidget {
  @override
  _StreaksScreenState createState() => _StreaksScreenState();
}

class _StreaksScreenState extends State<StreaksScreen> {
  String _selectedChartType = '1D';
  final List<String> chartTypes = ['1D', '1W', '1M', '3M', '1Y'];

  @override
  void initState() {
    // TODO: implement initState
    checkStreak(context.read<StreakProvider>());
    super.initState();

    print(streak);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<StreakProvider>(
      builder:(context, StreakProvider streakProvider,_){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Today\'s Goal: ${streakProvider.streakCount + 1} streak days',
                      style: TextThemeHelper.black_22_700,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColorHelper.boxColor,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Streak Days',
                            style: TextThemeHelper.black_16_500,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${streakProvider.streakCount}',
                            style: TextThemeHelper.black_24_700,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  'Daily Streak',
                  style: TextThemeHelper.black_16_500,
                ),
                Text(
                  '${streakProvider.streakCount}',
                  style: TextThemeHelper.black_24_700.copyWith(fontSize: 32),
                ),
                RichText(
                  // Controls visual overflow
                  overflow: TextOverflow.clip,
                  // Whether the text should break at soft line breaks
                  softWrap: true,

                  // Maximum number of lines for the text to span
                  maxLines: 1,

                  // The number of font pixels for each logical pixel
                  text: TextSpan(
                    text: 'Last 30 Days ',
                    style: TextThemeHelper.appColor_14_400.copyWith(fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' +100%',
                          style: TextThemeHelper.black_16_500
                              .copyWith(color: Color(0xff088759))),
                    ],
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.28,
                    child: SfCartesianChart(
                        plotAreaBorderWidth: 0.0,
                        primaryYAxis: NumericAxis(
                          majorTickLines: MajorTickLines(width: 0, size: 0),
                          minorTickLines: MinorTickLines(width: 0, size: 0),
                          majorGridLines: MajorGridLines(width: 0),
                          axisLine: AxisLine(
                            width: 0,
                          ),
                          labelStyle: TextStyle(fontSize: 0),
                        ),
                        primaryXAxis: NumericAxis(
                          majorTickLines: MajorTickLines(width: 0, size: 0),
                          minorTickLines: MinorTickLines(width: 0, size: 0),
                          minorGridLines: MinorGridLines(width: 0),
                          axisLine: AxisLine(width: 0),
                          majorGridLines: MajorGridLines(width: 0),
                          labelStyle: TextStyle(fontSize: 0),
                        ),
                        series: <CartesianSeries>[
                          SplineSeries<ChartData, int>(
                            color: Color(0xff964F66),
                            dataSource: _getChartData(_selectedChartType),
                            width: 3,
                            splineType: SplineType.cardinal,
                            cardinalSplineTension: 0.5,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y!,
                          )
                        ])),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: chartTypes.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedChartType = chartTypes[index];
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            chartTypes[index],
                            style: TextThemeHelper.appColor_14_400.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Keep it up! You\'re on a roll.',
                  style: TextThemeHelper.black_16_500
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: (){
                    dynamic navigationBar = globalKey!.currentWidget;
                    navigationBar.onTap(0);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    padding: EdgeInsets.all(9.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColorHelper.boxColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: TextThemeHelper.black_14_700,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  List<ChartData> _getChartData(data) {
    switch (data) {
      case '1D':
        return chartData;
      case '1W':
        // Generate weekly data
        return chartData1W;
      case '1M':
        // Generate monthly data
        return chartData1M;
      case '3M':
        // Generate monthly data
        return chartData3M;
      case '1Y':
        // Generate yearly data
        return chartData1Y;
      default:
        return chartData;
    }
  }
  checkStreak(StreakProvider streakProvider)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final productsString = prefs.getString('products');
    var data = Map<String, Map<String, dynamic>>.from(
      (jsonDecode(productsString!) as Map).map(
            (key, value) => MapEntry(
          key.toString(),
          (value as Map).cast<String, dynamic>(),
        ),
      ),
    );
    bool vale =
    data.values.every((element) => element['status'] == 'complete');
print(vale);
    if(vale == true){
      streakProvider.updateStreak();
    }
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final int x;
  final double y;
}
