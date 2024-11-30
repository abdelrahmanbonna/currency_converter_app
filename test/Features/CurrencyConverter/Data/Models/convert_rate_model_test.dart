import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConvertRateModel', () {
    const testBaseCurrency = 'USD';
    const testConvertCurrency = 'EUR';
    const testRate = 0.85;
    const testAmount = 100.0;
    final testFromDate = DateTime(2023, 1, 1);
    final testToDate = DateTime(2023, 12, 31);

    test('should be a subclass of ConvertRateEntity', () {
      // Arrange
      const model = ConvertRateModel(
        baseCurrency: testBaseCurrency,
        convertCurrency: testConvertCurrency,
      );

      // Assert
      expect(model, isA<ConvertRateEntity>());
    });

    group('fromEntity', () {
      test('should create a ConvertRateModel from a ConvertRateEntity', () {
        // Arrange
        final entity = ConvertRateEntity(
          baseCurrency: testBaseCurrency,
          convertCurrency: testConvertCurrency,
          amount: testAmount,
          rate: testRate,
          from: testFromDate,
          to: testToDate,
        );

        // Act
        final model = ConvertRateModel.fromEntity(entity);

        // Assert
        expect(model.baseCurrency, equals(testBaseCurrency));
        expect(model.convertCurrency, equals(testConvertCurrency));
        expect(model.amount, equals(testAmount));
        expect(model.rate, equals(testRate));
        expect(model.from, equals(testFromDate));
        expect(model.to, equals(testToDate));
      });
    });

    group('fromJson', () {
      test('should create a ConvertRateModel from JSON with valid data', () {
        // Arrange
        final json = {
          'results': {
            'USD_EUR': {
              'id': 'USD_EUR',
              'val': testRate,
              'to': testConvertCurrency,
              'fr': testBaseCurrency,
            },
          },
        };

        // Act
        final model = ConvertRateModel.fromJson(json);

        // Assert
        expect(model.baseCurrency, equals(testBaseCurrency));
        expect(model.convertCurrency, equals(testConvertCurrency));
        expect(model.rate, equals(testRate));
        expect(model.amount, equals(1.0)); // Default amount
      });

      test('should throw FormatException when JSON is invalid', () {
        // Arrange
        final invalidJson = {
          'results': {},
        };

        // Act & Assert
        expect(
          () => ConvertRateModel.fromJson(invalidJson),
          throwsA(isA<StateError>()),
        );
      });

      test('should throw NoSuchMethodError when rate is not a number', () {
        // Arrange
        final invalidJson = {
          'results': {
            'USD_EUR': {
              'id': 'USD_EUR',
              'val': 'not a number',
              'to': testConvertCurrency,
              'fr': testBaseCurrency,
            },
          },
        };

        // Act & Assert
        expect(
          () => ConvertRateModel.fromJson(invalidJson),
          throwsA(isA<NoSuchMethodError>()),
        );
      });
    });

    group('toJson', () {
      test('should convert ConvertRateModel to JSON', () {
        // Arrange
        const model = ConvertRateModel(
          baseCurrency: testBaseCurrency,
          convertCurrency: testConvertCurrency,
          rate: testRate,
          amount: testAmount,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['query']['count'], equals(1));
        expect(json['results']['USD_EUR']['id'], equals('USD_EUR'));
        expect(json['results']['USD_EUR']['val'], equals(testRate));
        expect(json['results']['USD_EUR']['to'], equals(testConvertCurrency));
        expect(json['results']['USD_EUR']['fr'], equals(testBaseCurrency));
      });
    });

    group('convertedAmount', () {
      test('should calculate converted amount correctly', () {
        // Arrange
        const model = ConvertRateModel(
          baseCurrency: testBaseCurrency,
          convertCurrency: testConvertCurrency,
          rate: testRate,
          amount: testAmount,
        );

        // Act & Assert
        expect(model.convertedAmount, equals(testAmount * testRate));
      });

      test('should return 0 when rate is 0', () {
        // Arrange
        const model = ConvertRateModel(
          baseCurrency: testBaseCurrency,
          convertCurrency: testConvertCurrency,
          rate: 0,
          amount: testAmount,
        );

        // Act & Assert
        expect(model.convertedAmount, equals(0));
      });

      test('should return 0 when amount is 0', () {
        // Arrange
        const model = ConvertRateModel(
          baseCurrency: testBaseCurrency,
          convertCurrency: testConvertCurrency,
          rate: testRate,
          amount: 0,
        );

        // Act & Assert
        expect(model.convertedAmount, equals(0));
      });
    });

    group('copyWith', () {
      test('should return a new instance with updated values', () {
        // Arrange
        final model = ConvertRateModel(
          baseCurrency: testBaseCurrency,
          convertCurrency: testConvertCurrency,
          rate: testRate,
          amount: testAmount,
          from: testFromDate,
          to: testToDate,
        );

        // Act
        final updatedModel = model.copyWith(
          amount: 200.0,
          rate: 0.9,
          convertCurrency: 'GBP',
          baseCurrency: 'JPY',
          from: DateTime(2024, 1, 1),
          to: DateTime(2024, 12, 31),
        );

        // Assert
        expect(updatedModel.amount, equals(200.0));
        expect(updatedModel.rate, equals(0.9));
        expect(updatedModel.convertCurrency, equals('GBP'));
        expect(updatedModel.baseCurrency, equals('JPY'));
        expect(updatedModel.from, equals(DateTime(2024, 1, 1)));
        expect(updatedModel.to, equals(DateTime(2024, 12, 31)));
      });

      test('should keep original values when parameters are null', () {
        // Arrange
        final model = ConvertRateModel(
          baseCurrency: testBaseCurrency,
          convertCurrency: testConvertCurrency,
          rate: testRate,
          amount: testAmount,
          from: testFromDate,
          to: testToDate,
        );

        // Act
        final updatedModel = model.copyWith();

        // Assert
        expect(updatedModel.amount, equals(testAmount));
        expect(updatedModel.rate, equals(testRate));
        expect(updatedModel.convertCurrency, equals(testConvertCurrency));
        expect(updatedModel.baseCurrency, equals(testBaseCurrency));
        expect(updatedModel.from, equals(testFromDate));
        expect(updatedModel.to, equals(testToDate));
      });
    });

    group('toMap', () {
      test('should convert ConvertRateModel to Map', () {
        // Arrange
        final model = ConvertRateModel(
          baseCurrency: testBaseCurrency,
          convertCurrency: testConvertCurrency,
          rate: testRate,
          amount: testAmount,
          from: testFromDate,
          to: testToDate,
        );

        // Act
        final map = model.toMap();

        // Assert
        expect(map['amount'], equals(testAmount));
        expect(map['rate'], equals(testRate));
        expect(map['convertCurrency'], equals(testConvertCurrency));
        expect(map['baseCurrency'], equals(testBaseCurrency));
        expect(map['from'], equals(testFromDate.toString()));
        expect(map['to'], equals(testToDate.toString()));
      });

      test('should handle null dates in toMap', () {
        // Arrange
        const model = ConvertRateModel(
          baseCurrency: testBaseCurrency,
          convertCurrency: testConvertCurrency,
          rate: testRate,
          amount: testAmount,
        );

        // Act
        final map = model.toMap();

        // Assert
        expect(map['from'], isNull);
        expect(map['to'], isNull);
      });
    });
  });
}
