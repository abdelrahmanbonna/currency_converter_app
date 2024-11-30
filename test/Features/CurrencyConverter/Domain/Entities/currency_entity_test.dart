import 'package:flutter_test/flutter_test.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/currency_entity.dart';

void main() {
  const tCurrencyEntity = CurrencyEntity(
    symbol: '\$',
    name: 'US Dollar',
    symbolNative: '\$',
    decimalDigits: 2,
    rounding: 0,
    code: 'USD',
    namePlural: 'US dollars',
    type: 'fiat',
  );

  group('CurrencyEntity', () {
    test('should create a valid CurrencyEntity instance', () {
      // Assert
      expect(tCurrencyEntity.symbol, '\$');
      expect(tCurrencyEntity.name, 'US Dollar');
      expect(tCurrencyEntity.symbolNative, '\$');
      expect(tCurrencyEntity.decimalDigits, 2);
      expect(tCurrencyEntity.rounding, 0);
      expect(tCurrencyEntity.code, 'USD');
      expect(tCurrencyEntity.namePlural, 'US dollars');
      expect(tCurrencyEntity.type, 'fiat');
    });

    test('fromJson should create a valid CurrencyEntity instance', () {
      // Arrange
      final json = {
        'symbol': '\$',
        'name': 'US Dollar',
        'symbol_native': '\$',
        'decimal_digits': 2,
        'rounding': 0,
        'code': 'USD',
        'name_plural': 'US dollars',
        'type': 'fiat',
      };

      // Act
      final result = CurrencyEntity.fromJson(json);

      // Assert
      expect(result, equals(tCurrencyEntity));
    });

    test('toJson should return a valid JSON map', () {
      // Act
      final result = tCurrencyEntity.toJson();

      // Assert
      final expectedJson = {
        'symbol': '\$',
        'name': 'US Dollar',
        'symbol_native': '\$',
        'decimal_digits': 2,
        'rounding': 0,
        'code': 'USD',
        'name_plural': 'US dollars',
        'type': 'fiat',
      };
      expect(result, equals(expectedJson));
    });

    test('copyWith should return a new instance with updated values', () {
      // Act
      final result = tCurrencyEntity.copyWith(
        symbol: '€',
        name: 'Euro',
      );

      // Assert
      expect(result.symbol, '€');
      expect(result.name, 'Euro');
      expect(result.symbolNative, tCurrencyEntity.symbolNative);
      expect(result.decimalDigits, tCurrencyEntity.decimalDigits);
      expect(result.rounding, tCurrencyEntity.rounding);
      expect(result.code, tCurrencyEntity.code);
      expect(result.namePlural, tCurrencyEntity.namePlural);
      expect(result.type, tCurrencyEntity.type);
    });

    test('copyWith should return the same instance if no parameters are passed', () {
      // Act
      final result = tCurrencyEntity.copyWith();

      // Assert
      expect(result, equals(tCurrencyEntity));
    });

    test('props should contain all fields', () {
      // Act
      final props = tCurrencyEntity.props;

      // Assert
      expect(props, [
        tCurrencyEntity.symbol,
        tCurrencyEntity.name,
        tCurrencyEntity.symbolNative,
        tCurrencyEntity.decimalDigits,
        tCurrencyEntity.rounding,
        tCurrencyEntity.code,
        tCurrencyEntity.namePlural,
        tCurrencyEntity.type,
      ]);
    });

    test('should support value equality', () {
      // Arrange
      const instance1 = CurrencyEntity(
        symbol: '\$',
        name: 'US Dollar',
        symbolNative: '\$',
        decimalDigits: 2,
        rounding: 0,
        code: 'USD',
        namePlural: 'US dollars',
        type: 'fiat',
      );

      const instance2 = CurrencyEntity(
        symbol: '\$',
        name: 'US Dollar',
        symbolNative: '\$',
        decimalDigits: 2,
        rounding: 0,
        code: 'USD',
        namePlural: 'US dollars',
        type: 'fiat',
      );

      // Assert
      expect(instance1, equals(instance2));
    });

    test('should handle null values correctly', () {
      // Arrange
      const currencyEntity = CurrencyEntity();

      // Assert
      expect(currencyEntity.symbol, null);
      expect(currencyEntity.name, null);
      expect(currencyEntity.symbolNative, null);
      expect(currencyEntity.decimalDigits, null);
      expect(currencyEntity.rounding, null);
      expect(currencyEntity.code, null);
      expect(currencyEntity.namePlural, null);
      expect(currencyEntity.type, null);
    });
  });
}
