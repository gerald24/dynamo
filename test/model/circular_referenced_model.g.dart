// GENERATED CODE - DO NOT MODIFY BY HAND

part of dynamo.test.model.circular;

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: class PersonRepository
// **************************************************************************

abstract class _$PersonRepositoryDynamoMixin
    implements DynamoProtocol<PersonRepository> {
  List<Person> persons;
  List<Tag> tags;

  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = _$dynamoEncodingSupport.newJsonSerializableMap(this);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'persons', this.persons);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'tags', this.tags);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    this.persons = _$dynamoDecodingSupport.decodeList(_$jsonMap[r'persons'],
        factory: () => new Person());
    this.tags = _$dynamoDecodingSupport.decodeList(_$jsonMap[r'tags'],
        factory: () => new Tag());
  }
}

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: class Person
// **************************************************************************

abstract class _$PersonDynamoMixin implements DynamoProtocol<Person> {
  int id;
  String name;
  Person parent;

  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = _$dynamoEncodingSupport.newJsonSerializableMap(this);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'id', this.id);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'name', this.name);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'parent', this.parent);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    this.id = _$jsonMap[r'id'];
    this.name = _$jsonMap[r'name'];
    this.parent = _$dynamoDecodingSupport.decodeSupported(_$jsonMap[r'parent'],
        factory: () => new Person());
  }
}

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: class Tag
// **************************************************************************

abstract class _$TagDynamoMixin implements DynamoProtocol<Tag> {
  int id;
  String name;
  List<Person> persons;

  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = _$dynamoEncodingSupport.newJsonSerializableMap(this);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'id', this.id);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'name', this.name);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'persons', this.persons);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    this.id = _$jsonMap[r'id'];
    this.name = _$jsonMap[r'name'];
    this.persons = _$dynamoDecodingSupport.decodeList(_$jsonMap[r'persons'],
        factory: () => new Person());
  }
}
