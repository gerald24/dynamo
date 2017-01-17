/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

part of dynamo;

class _DynamoImpl implements Dynamo {
  final _Context _context;
  final Codec _codec;

  _DynamoImpl(this._codec, String logIdentifier) : _context = new _Context(logIdentifier) {
    _context.log.fine('Initiate Dynamo.');
  }

  void addTransformer(TypeTransformer transformer) {
    _context.transformers.add(transformer);
    _context.log.fine('Transformer ${transformer} added');
  }

  void registerType(String identifier, Type type, InstanceFactory factory) {
    _context.types[identifier] = type;
    _context.factories[identifier] = factory;
    _context.log.fine('Type ${type} registered with identifier ${identifier}');
  }

  String get typeKey => _context.typeKey;

  String get instanceIdKey => _context.instanceIdKey;

  String get referenceKey => _context.referenceKey;

  void set typeKey(String key) {
    _context.log.finer('using typeKey ${key}');
    _context.typeKey = key;
  }

  void set instanceIdKey(String key) {
    _context.log.finer('using instanceIdKey ${key}');
    _context.instanceIdKey = key;
  }

  void set referenceKey(String key) {
    _context.log.finer('using referenceKey ${key}');
    _context.referenceKey = key;
  }

  String toJson(dynamic value) {
    _context.log.finest('encode ${value}');
    var encoder = new _Encoder(new _EncodingReferenceMapper(_context), _context);
    return _codec.encode(encoder._encodeDynamic(value));
  }

  dynamic fromJson(String json, {Object factory()}) {
    _context.log.finest('decode ${json}');
    var decoder = new _Decoder(new _DecodingReferenceMapper(_context), _context);
    if (factory == null) {
      return decoder._decodeDynamic(_codec.decode(json));
    } else {
      return decoder.decodeSupported(_codec.decode(json), factory: factory);
    }
  }
}

class _Context {
  final Logger log;

  final Map<String, Type> types = {};
  final Map<String, InstanceFactory> factories = {};
  final List<TypeTransformer> transformers = [];

  String typeKey = r'_isa_';
  String instanceIdKey = r'_id#_';
  String referenceKey = r'_ref_';

  _Context(String logIdentifier) : log = new Logger(logIdentifier);
}
