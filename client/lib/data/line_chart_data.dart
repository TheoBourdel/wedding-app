import 'package:fl_chart/fl_chart.dart';

class LineData {
  List<FlSpot> spots;
  Map<int, String> leftTitle;
  Map<int, String> bottomTitle;

  LineData({required this.spots, required this.leftTitle, required this.bottomTitle});

  // Factory method to create LineData from JSON
  factory LineData.fromJson(List<dynamic> json) {
    List<FlSpot> spots = json.map((data) => FlSpot(
        (data['month'] as int).toDouble(),
        (data['revenue'] as num).toDouble()
    )).toList();

    Map<int, String> bottomTitle = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };

    double maxY = spots.isNotEmpty ? spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) : 0;

    Map<int, String> leftTitle = {
      0: '0',
      (maxY / 5).round(): ((maxY / 5) / 1000).round().toString() + 'K',
      (maxY * 2 / 5).round(): ((maxY * 2 / 5) / 1000).round().toString() + 'K',
      (maxY * 3 / 5).round(): ((maxY * 3 / 5) / 1000).round().toString() + 'K',
      (maxY * 4 / 5).round(): ((maxY * 4 / 5) / 1000).round().toString() + 'K',
      maxY.round(): (maxY / 1000).round().toString() + 'K'
    };

    return LineData(spots: spots, leftTitle: leftTitle, bottomTitle: bottomTitle);
  }
}
