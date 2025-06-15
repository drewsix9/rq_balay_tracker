import '../../../../core/theme/app_colors.dart';
import '../../viewmodel/charts_viewmodel.dart';
import 'base_monthly_consumption_chart.dart';

class MonthlyWaterConsumptionWidget extends BaseMonthlyConsumptionChart {
  const MonthlyWaterConsumptionWidget.monthlyWaterConsumptionChart({
    super.key,
    super.chartKey,
  }) : super(chartGradient: AppGradients.primaryBlueGradient);

  @override
  List<double> getConsumptionData(ChartsViewModel provider) {
    return provider.waterChartModel!.consumptions;
  }

  @override
  List<String> getMonthsData(ChartsViewModel provider) {
    return provider.waterChartModel!.rMonth;
  }
}
