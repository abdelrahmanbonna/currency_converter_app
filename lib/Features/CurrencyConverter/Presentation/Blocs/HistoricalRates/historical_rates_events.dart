import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:equatable/equatable.dart';

abstract class HistoricalRatesEvent extends Equatable {
  const HistoricalRatesEvent();
}

class GetHistoricalRatesEvent extends HistoricalRatesEvent {
  final ConvertRateEntity convertRateEntity;
  const GetHistoricalRatesEvent(this.convertRateEntity);
  @override
  List<Object> get props => [convertRateEntity];
}
