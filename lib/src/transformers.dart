/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

part of dynamo;

/// The interface for creating new transformers.
/// For a basic example on how to use this interface take a look at [DateTimeParser].
/// Transformers can also be used to serialize just some values (foreign keys)
/// in order to identify an instance (by key).
///
/// Sample:
///   class PersonTransformer implements TypeTransformer<Person> {
///     static const String KEY = 'personid';
///     final PersonRepository repository;
///
///     PersonTransformer(this.repository);
///
///     @override
///     bool canEncode(value) => value is Person;
///
///     @override
///     encode(Person value) => {KEY: value.id};
///
///     @override
///     bool canDecode(value) => value is Map && value.containsKey(KEY);
///
///     @override
///     Person decode(value) => repository.findById(value[KEY]);
///   }
abstract class TypeTransformer<T> {

  /// this is for unknown types (e.g. value is part of an untyped list)
  bool canEncode(dynamic value);

  /// Receives the [value] of type [T] and returns a serializable result which
  /// will be passed into the JSON representation.
  dynamic encode(T value);


  /// this is for unknown types (e.g. value is part of an untyped list)
  bool canDecode(dynamic value);

  /// Takes a serialized [value] from the JSON object and transforms it into the
  /// correct type.
  T decode(dynamic value);
}

/// transformer for [DateTime] values to and from a json object.
/// Pass a key as identifier. E.g. passing key '_mydatetime' will result in
/// a json object like {"_mydatetime":"2016-12-24T12:59:33.000Z"}.
///
class DateTimeTransformer extends TypeTransformer<DateTime> {
  String key;

  DateTimeTransformer(this.key);

  bool canEncode(dynamic value) => value is DateTime;

  dynamic encode(DateTime value) => {key: value.toUtc().toIso8601String()};

  bool canDecode(dynamic value) => value is Map && value.length == 1 && value[key] is String;

  DateTime decode(dynamic value) => DateTime.parse(value[key]);
}
