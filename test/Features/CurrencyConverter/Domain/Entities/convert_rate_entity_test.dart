import 'package:flutter_test/flutter_test.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';

void main() {
  final now = DateTime.now();
  final tConvertRateEntity = ConvertRateEntity(
    amount: 100,
    rate: 0.85,
    convertCurrency: 'EUR',
    baseCurrency: 'USD',
    from: now,
    to: now.add(const Duration(days: 1)),
  );

  group('ConvertRateEntity', () {
    test('should create a valid ConvertRateEntity instance', () {
      // Assert
      expect(tConvertRateEntity.amount, 100);
      expect(tConvertRateEntity.rate, 0.85);
      expect(tConvertRateEntity.convertCurrency, 'EUR');
      expect(tConvertRateEntity.baseCurrency, 'USD');
      expect(tConvertRateEntity.from, now);
      expect(tConvertRateEntity.to, now.add(const Duration(days: 1)));
    });

    test('should calculate converted amount correctly', () {
      // Act
      final convertedAmount = tConvertRateEntity.convertedAmount;

      // Assert
      expect(convertedAmount, tConvertRateEntity.amount * tConvertRateEntity.rate);
      expect(convertedAmount, 85.0); // 100 * 0.85
    });

    test('copyWith should return a new instance with updated values', () {
      // Act
      final result = tConvertRateEntity.copyWith(
        amount: 200,
        rate: 0.9,
      );

      // Assert
      expect(result.amount, 200);
      expect(result.rate, 0.9);
      expect(result.convertCurrency, tConvertRateEntity.convertCurrency);
      expect(result.baseCurrency, tConvertRateEntity.baseCurrency);
      expect(result.from, tConvertRateEntity.from);
      expect(result.to, tConvertRateEntity.to);
    });

    test('copyWith should return the same instance if no parameters are passed', () {
      // Act
      final result = tConvertRateEntity.copyWith();

      // Assert
      expect(result, equals(tConvertRateEntity));
    });

    test('toMap should return a valid map', () {
      // Act
      final result = tConvertRateEntity.toMap();

      // Assert
      final expectedMap = {
        'amount': 100.0,
        'rate': 0.85,
        'convertCurrency': 'EUR',
        'baseCurrency': 'USD',
        'from': tConvertRateEntity.from?.toString(),
        'to': tConvertRateEntity.to?.toString(),
      };
      expect(result, equals(expectedMap));
    });

    test('props should contain all fields', () {
      // Act
      final props = tConvertRateEntity.props;

      // Assert
      expect(props, [
        tConvertRateEntity.amount,
        tConvertRateEntity.rate,
        tConvertRateEntity.convertCurrency,
        tConvertRateEntity.baseCurrency,
        tConvertRateEntity.from,
        tConvertRateEntity.to,
      ]);
    });

    test('should support value equality', () {
      // Arrange
      final instance1 = ConvertRateEntity(
        amount: 100,
        rate: 0.85,
        convertCurrency: 'EUR',
        baseCurrency: 'USD',
        from: now,
        to: now.add(const Duration(days: 1)),
      );

      final instance2 = ConvertRateEntity(
        amount: 100,
        rate: 0.85,
        convertCurrency: 'EUR',
        baseCurrency: 'USD',
        from: now,
        to: now.add(const Duration(days: 1)),
      );

      // Assert
      expect(instance1, equals(instance2));
    });

    test('should initialize with default values correctly', () {
      // Arrange
      const entity = ConvertRateEntity(
        convertCurrency: 'EUR',
        baseCurrency: 'USD',
      );

      // Assert
      expect(entity.amount, 0);
      expect(entity.rate, 0);
      expect(entity.convertCurrency, 'EUR');
      expect(entity.baseCurrency, 'USD');
      expect(entity.from, null);
      expect(entity.to, null);
    });

    test('convertedAmount should be zero when rate is zero', () {
      // Arrange
      const entity = ConvertRateEntity(
        amount: 100,
        rate: 0,
        convertCurrency: 'EUR',
        baseCurrency: 'USD',
      );

      // Assert
      expect(entity.convertedAmount, 0);
    });

    test('convertedAmount should be zero when amount is zero', () {
      // Arrange
      const entity = ConvertRateEntity(
        amount: 0,
        rate: 0.85,
        convertCurrency: 'EUR',
        baseCurrency: 'USD',
      );

      // Assert
      expect(entity.convertedAmount, 0);
    });
  });
}
