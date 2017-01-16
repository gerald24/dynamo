/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

part of dynamo;

class _Encoder extends DynamoEncodingSupport {

  final _EncodingReferenceMapper mapper;
  final _Context _context;

  _Encoder(this.mapper, this._context);

  @override
  Map<String, dynamic> newJsonSerializableMap(dynamic instance) {
    Map<String, dynamic> serializedObject = {};
    if (mapper != null) {
      mapper.registerSerializableMap(instance, serializedObject);
    }

    var key = _context.types.keys.firstWhere((key) => _context.types[key] == instance.runtimeType, orElse: () => null);
    if (key != null) {
      serializedObject.putIfAbsent(_context.typeKey, () => key);
    }
    return serializedObject;
  }

  @override
  void addValue(Map<String, dynamic> $jsonMap, String name, dynamic value) {
    var encodedValue = _encodeDynamic(value);
    if (encodedValue != null) {
      $jsonMap[name] = encodedValue;
    }
  }

  _encodeList(List list) {
    return list == null ? null : list.map((i) => _encodeDynamic(i)).toList();
  }

  _encodeMap(Map map) {
    if (map == null) {
      return null;
    }
    Map newMap = new Map<String, Object>();
    map.forEach((key, val) {
      if (val != null) newMap[key] = _encodeDynamic(val);
    });
    return newMap;
  }

  _encodeDateTime(DateTime value) {
    return value?.toUtc()?.toIso8601String();
  }

  dynamic _encodeSupported<T extends DynamoProtocol>(DynamoProtocol<T> instance) {
    if (instance == null) {
      return null;
    }
    if (_isSerialized(instance)) {
      return _createPlaceholder(instance);
    }
    return instance.asJsonSerializableMap(this);
  }

  _encodeDynamic(dynamic value) {
    if (value == null) {
      return null;
    }
    var transformer = _context.transformers.firstWhere((transformer) => transformer.canEncode(value), orElse: () => null);
    if (transformer != null) {
      return transformer.encode(value);
    }
    if (value is bool || value is num || value is String) {
      return value;
    }
    if (value is List) {
      return _encodeList(value);
    }
    if (value is Map) {
      return _encodeMap(value);
    }
    if (value is DateTime) {
      return _encodeDateTime(value);
    }
    if (value is DynamoProtocol) {
      return _encodeSupported(value);
    }
    throw 'Can not encode ${value}. Types must implement DynamoProtocol which can be generated.';
  }

  bool _isSerialized(dynamic instance) {
    return mapper.isSerialized(instance);
  }

  Map _createPlaceholder(dynamic instance) {
    return mapper.createSerializablePlaceholder(instance);
  }
}


/// Registers instances (serializable maps) and create serializable placeholders for them.
/// An [INSTANCE_ID] will be added to the serializable maps in case a placeholder was created.
/// A placeholder is a serializable map, which contains a [REFERENCE_ID] entry.
class _EncodingReferenceMapper {
  int lastId = 0;
  Map<Object, Map> serializableMapsByInstance = new Map.identity();
  _Context _context;

  _EncodingReferenceMapper(this._context);

  void registerSerializableMap(Object value, dynamic serializedObject) {
    if (serializedObject is Map) {
      serializableMapsByInstance.putIfAbsent(value, () => serializedObject);
    }
  }

  bool isSerialized(Object instance) {
    return serializableMapsByInstance.containsKey(instance);
  }

  Map createSerializablePlaceholder(Object instance) {
    var serializableMap = serializableMapsByInstance[instance];
    // if placeholder is needed for object add reference id to serialized object
    serializableMap.putIfAbsent(_context.instanceIdKey, () => ++lastId);
    return {_context.referenceKey: serializableMap[_context.instanceIdKey]};
  }
}

