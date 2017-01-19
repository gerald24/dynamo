// GENERATED CODE - DO NOT MODIFY BY HAND

part of dynamo_example;

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: class Member
// **************************************************************************

abstract class _$MemberDynamoMixin implements DynamoProtocol<Member> {
  int get id;
  set id(int value);
  String get title;
  set title(String value);
  String get firstName;
  set firstName(String value);
  String get lastName;
  set lastName(String value);
  String get birthday;
  set birthday(String value);
  String get email;
  set email(String value);
  String get phoneNumber;
  set phoneNumber(String value);
  String get street;
  set street(String value);
  String get city;
  set city(String value);
  String get postalCode;
  set postalCode(String value);
  String get country;
  set country(String value);
  MemberType get type;
  set type(MemberType value);
  String get notes;
  set notes(String value);
  bool get active;
  set active(bool value);
  bool get registrationFeePaid;
  set registrationFeePaid(bool value);
  List<Tag> get tags;
  set tags(List<Tag> value);

  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = _$dynamoEncodingSupport.newJsonSerializableMap(this);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'id', this.id);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'title', this.title);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'firstName', this.firstName);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'lastName', this.lastName);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'birthday', this.birthday);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'email', this.email);
    _$dynamoEncodingSupport.addValue(
        _$jsonMap, r'phoneNumber', this.phoneNumber);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'street', this.street);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'city', this.city);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'postalCode', this.postalCode);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'country', this.country);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'type', this.type);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'notes', this.notes);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'active', this.active);
    _$dynamoEncodingSupport.addValue(
        _$jsonMap, r'registrationFeePaid', this.registrationFeePaid);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'tags', this.tags);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    this.id = _$jsonMap[r'id'];
    this.title = _$jsonMap[r'title'];
    this.firstName = _$jsonMap[r'firstName'];
    this.lastName = _$jsonMap[r'lastName'];
    this.birthday = _$jsonMap[r'birthday'];
    this.email = _$jsonMap[r'email'];
    this.phoneNumber = _$jsonMap[r'phoneNumber'];
    this.street = _$jsonMap[r'street'];
    this.city = _$jsonMap[r'city'];
    this.postalCode = _$jsonMap[r'postalCode'];
    this.country = _$jsonMap[r'country'];
    this.type = _$jsonMap[r'type'];
    this.notes = _$jsonMap[r'notes'];
    this.active = _$jsonMap[r'active'];
    this.registrationFeePaid = _$jsonMap[r'registrationFeePaid'];
    this.tags = _$dynamoDecodingSupport.decodeList(_$jsonMap[r'tags'],
        factory: () => new Tag()) as List<Tag>;
  }
}

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: class Tag
// **************************************************************************

abstract class _$TagDynamoMixin implements DynamoProtocol<Tag> {
  int get id;
  set id(int value);
  String get name;
  set name(String value);

  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = _$dynamoEncodingSupport.newJsonSerializableMap(this);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'id', this.id);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'name', this.name);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    this.id = _$jsonMap[r'id'];
    this.name = _$jsonMap[r'name'];
  }
}

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: abstract class Message
// **************************************************************************

abstract class _$MessageDynamoMixin implements DynamoProtocol<Message> {
  int get id;
  set id(int value);

  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = _$dynamoEncodingSupport.newJsonSerializableMap(this);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'id', this.id);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    this.id = _$jsonMap[r'id'];
  }
}

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: class AllMembersRequest
// **************************************************************************

abstract class _$AllMembersRequestDynamoMixin
    implements DynamoProtocol<AllMembersRequest> {
  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = super.asJsonSerializableMap(_$dynamoEncodingSupport);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    super.fromJsonSerializableMap(_$jsonMap, _$dynamoDecodingSupport);
  }
}

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: class AllMembersResponse
// **************************************************************************

abstract class _$AllMembersResponseDynamoMixin
    implements DynamoProtocol<AllMembersResponse> {
  List<Tag> get tags;
  set tags(List<Tag> value);
  List<Member> get members;
  set members(List<Member> value);

  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = super.asJsonSerializableMap(_$dynamoEncodingSupport);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'tags', this.tags);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'members', this.members);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    super.fromJsonSerializableMap(_$jsonMap, _$dynamoDecodingSupport);
    this.tags = _$dynamoDecodingSupport.decodeList(_$jsonMap[r'tags'],
        factory: () => new Tag()) as List<Tag>;
    this.members = _$dynamoDecodingSupport.decodeList(_$jsonMap[r'members'],
        factory: () => new Member()) as List<Member>;
  }
}
