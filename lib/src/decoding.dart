/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

part of dynamo;

class _Decoder extends DynamoDecodingSupport {

  final _DecodingReferenceMapper mapper;
  final _Context _context;

  _Decoder(this.mapper, this._context);

  @override
  List decodeList(value, {Object factory()}) {
    if (value == null) {
      return null;
    }
    return value.map((i) => decodeDynamic(i, factory: factory)).toList();
  }

  @override
  Map decodeMap(value, {Object factory()}) {
    if (value == null) {
      return null;
    }
    Map newMap = new Map<String, Object>();
    value.forEach((key, val) {
      if (val != null) newMap[key] = decodeDynamic(val, factory: factory);
    });
    return newMap;
  }

  @override
  DateTime decodeDateTime(value) {
    if (value == null) {
      return null;
    }
    var transformer = _context.transformers.firstWhere((transformer) => transformer.canDecode(value), orElse: () => null);
    if (transformer != null) {
      return transformer.decode(value);
    }
    return DateTime.parse(value);
  }

  @override
  dynamic decodeSupported(dynamic value, {Object factory()}) {
    if (value == null) {
      return null;
    }
    if (_isPlaceholder(value)) {
      return _resolveReferenceForPlaceholder(value);
    }
    if (value is! Map) {
      throw 'Map expected instead of ${value} ';
    }
    var target = null;
    var key = value[_context.typeKey];
    if (key != null) {
      var registeredFactory = _context.factories[key];
      if (registeredFactory != null) {
        target = registeredFactory();
      } else {
        throw 'No factory for ${key}';
      }
    } else {
      target = factory();
    }
    if (target is DynamoProtocol) {
      _registerInstanceIfApplicable(target, value);
      target.fromJsonSerializableMap(value, this);
      return target;
    }
    throw 'Can not decode ${value} into ${target}.';
  }

  dynamic decodeDynamic(dynamic value, {Object factory()}) {
    if (value == null) {
      return null;
    }
    if (_isPlaceholder(value)) {
      return _resolveReferenceForPlaceholder(value);
    }
    var transformer = _context.transformers.firstWhere((transformer) => transformer.canDecode(value), orElse: () => null);
    if (transformer != null) {
      return transformer.decode(value);
    }
    if (value is bool || value is num || value is String) {
      return value;
    }
    if (value is List) {
      return decodeList(value, factory: factory);
    }
    if (value is Map) {
      if (value[_context.typeKey] == null) {
        if (factory == null) {
          return decodeMap(value, factory: factory);
        } else {
          return decodeSupported(value, factory: factory);
        }
      } else {
        return decodeSupported(value, factory: factory);
      }
    }
    return value;
  }

  void _registerInstanceIfApplicable(dynamic instance, Map<String, dynamic> serializableMap) {
    mapper.registerInstanceIfApplicable(instance, serializableMap);
  }

  bool _isPlaceholder(dynamic val) {
    return mapper.isPlaceholder(val);
  }

  dynamic _resolveReferenceForPlaceholder(dynamic placeholder) {
    return mapper.resolveReferenceForPlaceholder(placeholder);
  }

  throwAbstractClassError() {
    throw 'Can not intantiate an abstract class. Register subclasses using registerType';
  }

}


/// Registers instances (serializable maps) if they contain an [INSTANCE_ID] entry,
/// and resolve references for placeholders.
/// A placeholder is a serializable map, which contains a [REFERENCE_ID] entry.
class _DecodingReferenceMapper {
  Map<int, Object> instancesById = {};
  _Context _context;

  _DecodingReferenceMapper(this._context);

  void registerInstanceIfApplicable(Object instance, Map serializableMap) {
    if (serializableMap.containsKey(_context.instanceIdKey)) {
      instancesById.putIfAbsent(serializableMap[_context.instanceIdKey], () => instance);
    }
  }

  bool isPlaceholder(Object value) {
    return value is Map && value.length == 1 && value.containsKey(_context.referenceKey);
  }

  Object resolveReferenceForPlaceholder(Map placeholder) {
    return instancesById[placeholder[_context.referenceKey]];
  }
}
