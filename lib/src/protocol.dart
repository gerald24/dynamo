/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

part of dynamo;


/// protocol for serialization. Needs to be implemented by serializeable object
abstract class DynamoProtocol<T> {
  /// Converts the object into a serializable Map.
  Map<String, dynamic> asJsonSerializableMap(DynamoEncodingSupport encodingSupport);

  /// Maps the [object] properties on this object.
  void fromJsonSerializableMap(Map<String, dynamic> jsonMap, DynamoDecodingSupport context);
}

abstract class DynamoEncodingSupport {

  Map<String, dynamic> newJsonSerializableMap(dynamic instance);

  void addValue(Map<String, dynamic> $jsonMap, String name, dynamic value);
}

abstract class DynamoDecodingSupport {

  List decodeList(dynamic value);

  Map decodeMap(dynamic value);

  DateTime decodeDateTime(dynamic value);

  dynamic decodeSupported(dynamic value);

  dynamic decodeDynamic(dynamic value);

  throwAbstractClassError();
}