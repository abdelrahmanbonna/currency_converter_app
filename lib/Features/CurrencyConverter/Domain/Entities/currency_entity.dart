import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class CurrencyEntity extends Equatable {
  final String? symbol;
  final String? name;
  final String? symbolNative;
  final num? decimalDigits;
  final num? rounding;
  final String? code;
  final String? namePlural;
  final String? type;

  const CurrencyEntity({
    this.symbol,
    this.name,
    this.symbolNative,
    this.decimalDigits,
    this.rounding,
    this.code,
    this.namePlural,
    this.type,
  });

  CurrencyEntity.fromJson(dynamic json)
      : symbol = json['symbol'],
        name = json['name'],
        symbolNative = json['symbol_native'],
        decimalDigits = json['decimal_digits'],
        rounding = json['rounding'],
        code = json['code'],
        namePlural = json['name_plural'],
        type = json['type'];

  CurrencyEntity copyWith({
    String? symbol,
    String? name,
    String? symbolNative,
    num? decimalDigits,
    num? rounding,
    String? code,
    String? namePlural,
    String? type,
  }) =>
      CurrencyEntity(
        symbol: symbol ?? this.symbol,
        name: name ?? this.name,
        symbolNative: symbolNative ?? this.symbolNative,
        decimalDigits: decimalDigits ?? this.decimalDigits,
        rounding: rounding ?? this.rounding,
        code: code ?? this.code,
        namePlural: namePlural ?? this.namePlural,
        type: type ?? this.type,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['symbol'] = symbol;
    map['name'] = name;
    map['symbol_native'] = symbolNative;
    map['decimal_digits'] = decimalDigits;
    map['rounding'] = rounding;
    map['code'] = code;
    map['name_plural'] = namePlural;
    map['type'] = type;
    return map;
  }

  @override
  List<Object?> get props => [
        symbol,
        name,
        symbolNative,
        decimalDigits,
        rounding,
        code,
        namePlural,
        type,
      ];
}
