/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo;

import 'dart:convert' show Codec, JSON;

import 'package:logging/logging.dart';

part 'src/annotations.dart';
part 'src/protocol.dart';
part 'src/serializer.dart';
part 'src/encoding.dart';
part 'src/decoding.dart';
part 'src/transformers.dart';

typedef T InstanceFactory<T>();

abstract class Dynamo {

  void registerType(String identifier, Type type, InstanceFactory factory);
  void addTransformer(TypeTransformer transformer);

  String toJson(dynamic value);
  dynamic fromJson(String json, {InstanceFactory factory});

  String get typeKey;
  String get instanceIdKey;
  String get referenceKey;

  void set typeKey(String key);
  void set instanceIdKey(String key);
  void set referenceKey(String key);

  factory Dynamo({Codec codec: JSON, String logIdentifier = 'dynamo'}) => new _DynamoImpl(codec, logIdentifier);
}
