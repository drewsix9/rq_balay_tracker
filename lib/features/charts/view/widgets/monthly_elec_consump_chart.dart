import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/charts_provider.dart';
import 'base_monthly_consumption_chart.dart';

class MonthlyElectricityConsumptionWidget extends BaseMonthlyConsumptionChart {
  const MonthlyElectricityConsumptionWidget.monthlyElectricityConsumptionChart({
    super.key,
    super.chartKey,
    super.showContainer,
  }) : super(
         chartGradient: AppGradients.warningGradient,
         chartType: 'electricity',
       );

  @override
  Future<List<double>> getConsumptionData(ChartsProvider provider) async {
    return provider.electricityChartModel?.consumptions ?? [];
  }

  @override
  Future<List<String>> getMonthsData(ChartsProvider provider) async {
    return provider.electricityChartModel?.rMonth ?? [];
  }
}
