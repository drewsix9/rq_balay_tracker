import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/charts_viewmodel.dart';
import 'base_monthly_consumption_chart.dart';

class MonthlyElectricityConsumptionWidget extends BaseMonthlyConsumptionChart {
  const MonthlyElectricityConsumptionWidget.monthlyElectricityConsumptionChart({
    super.key,
    super.chartKey,
  }) : super(
         chartGradient: AppGradients.warningGradient,
         chartType: 'electricity',
       );

  @override
  Future<List<double>> getConsumptionData(ChartsViewModel provider) async {
    return provider.electricityChartModel?.consumptions ?? [];
  }

  @override
  Future<List<String>> getMonthsData(ChartsViewModel provider) async {
    return provider.electricityChartModel?.rMonth ?? [];
  }
}
