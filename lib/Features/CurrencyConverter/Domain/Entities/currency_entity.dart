/// symbol : "$"
/// name : "US Dollar"
/// symbol_native : "$"
/// decimal_digits : 2
/// rounding : 0
/// code : "USD"
/// name_plural : "US dollars"
/// type : "fiat"

class CurrencyEntity {
  String? _symbol;
  String? _name;
  String? _symbolNative;
  num? _decimalDigits;
  num? _rounding;
  String? _code;
  String? _namePlural;
  String? _type;

  CurrencyEntity({
    String? symbol,
    String? name,
    String? symbolNative,
    num? decimalDigits,
    num? rounding,
    String? code,
    String? namePlural,
    String? type,
  }) {
    _symbol = symbol;
    _name = name;
    _symbolNative = symbolNative;
    _decimalDigits = decimalDigits;
    _rounding = rounding;
    _code = code;
    _namePlural = namePlural;
    _type = type;
  }

  CurrencyEntity.fromJson(dynamic json) {
    _symbol = json['symbol'];
    _name = json['name'];
    _symbolNative = json['symbol_native'];
    _decimalDigits = json['decimal_digits'];
    _rounding = json['rounding'];
    _code = json['code'];
    _namePlural = json['name_plural'];
    _type = json['type'];
  }

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
        symbol: symbol ?? _symbol,
        name: name ?? _name,
        symbolNative: symbolNative ?? _symbolNative,
        decimalDigits: decimalDigits ?? _decimalDigits,
        rounding: rounding ?? _rounding,
        code: code ?? _code,
        namePlural: namePlural ?? _namePlural,
        type: type ?? _type,
      );

  String? get symbol => _symbol;

  String? get name => _name;

  String? get symbolNative => _symbolNative;

  num? get decimalDigits => _decimalDigits;

  num? get rounding => _rounding;

  String? get code => _code;

  String? get namePlural => _namePlural;

  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['symbol'] = _symbol;
    map['name'] = _name;
    map['symbol_native'] = _symbolNative;
    map['decimal_digits'] = _decimalDigits;
    map['rounding'] = _rounding;
    map['code'] = _code;
    map['name_plural'] = _namePlural;
    map['type'] = _type;
    return map;
  }
}
