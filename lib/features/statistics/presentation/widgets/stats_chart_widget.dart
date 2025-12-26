import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

class StatsChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final String chartType; // 'bar' or 'line'

  const StatsChartWidget({
    super.key,
    required this.data,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkGrey40
              : AppColors.lightGrey10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('No data available')),
      );
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkGrey40
            : AppColors.lightGrey10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkGrey20
              : AppColors.lightGrey40,
          width: 1,
        ),
      ),
      child: chartType == 'bar' ? _buildBarChart() : _buildLineChart(),
    );
  }

  Widget _buildBarChart() {
    final entries = data.entries.toList();
    final maxValue = entries
        .map((e) => e.value)
        .reduce((value, element) => value > element ? value : element);

    final barGroups = List.generate(
      entries.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entries[index].value,
            color: AppColors.primaryColor,
            width: 12,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      ),
    );

    return BarChart(
      BarChartData(
        maxY: maxValue > 0 ? maxValue : 1,
        barGroups: barGroups,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= entries.length) {
                  return const Text('');
                }
                return Text(
                  entries[index].key.replaceAll('Day ', ''),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    final entries = data.entries.toList();
    final maxValue = entries
        .map((e) => e.value)
        .reduce((value, element) => value > element ? value : element);

    final spots = List.generate(
      entries.length,
      (index) => FlSpot(index.toDouble(), entries[index].value),
    );

    return LineChart(
      LineChartData(
        maxY: maxValue > 0 ? maxValue : 1,
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= entries.length) {
                  return const Text('');
                }
                return Text(
                  entries[index].key.replaceAll('Day ', ''),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primaryColor,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
