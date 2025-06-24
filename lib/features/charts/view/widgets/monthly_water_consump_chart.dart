import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/charts_viewmodel.dart';
import 'base_monthly_consumption_chart.dart';

class MonthlyWaterConsumptionWidget extends BaseMonthlyConsumptionChart {
  const MonthlyWaterConsumptionWidget.monthlyWaterConsumptionChart({
    super.key,
    super.chartKey,
  }) : super(
         chartGradient: AppGradients.primaryBlueGradient,
         chartType: 'water',
       );

  @override
  Future<List<double>> getConsumptionData(ChartsViewModel provider) async {
    return provider.waterChartModel!.consumptions;
  }

  @override
  Future<List<String>> getMonthsData(ChartsViewModel provider) async {
    return provider.waterChartModel!.rMonth;
  }
}
