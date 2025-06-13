import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/charts_viewmodel.dart';
import 'base_monthly_consumption_chart.dart';

class MonthlyElectricityConsumptionWidget extends BaseMonthlyConsumptionChart {
  const MonthlyElectricityConsumptionWidget.MonthlyElectricityConsumptionChart({
    super.key,
    super.chartKey,
  }) : super(chartGradient: AppGradients.warningGradient);

  @override
  List<double> getConsumptionData(ChartsViewModel provider) {
    return provider.electricityChartModel!.consumptions;
  }

  @override
  List<String> getMonthsData(ChartsViewModel provider) {
    return provider.electricityChartModel!.rMonth;
  }
}
