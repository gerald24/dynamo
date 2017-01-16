// GENERATED CODE - DO NOT MODIFY BY HAND

part of dynamo.test.model.polymorphic;

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: class Company
// **************************************************************************

abstract class _$CompanyDynamoMixin implements DynamoProtocol<Company> {
  List<Employee> employees;

  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = _$dynamoEncodingSupport.newJsonSerializableMap(this);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'employees', this.employees);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    this.employees = _$dynamoDecodingSupport.decodeList(_$jsonMap[r'employees'],
        factory: () => new Employee());
  }
}

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: class Employee
// **************************************************************************

abstract class _$EmployeeDynamoMixin implements DynamoProtocol<Employee> {
  String name;

  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = _$dynamoEncodingSupport.newJsonSerializableMap(this);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'name', this.name);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    this.name = _$jsonMap[r'name'];
  }
}

// **************************************************************************
// Generator: DynamoMixinGenerator
// Target: class Manager
// **************************************************************************

abstract class _$ManagerDynamoMixin implements DynamoProtocol<Manager> {
  List<Employee> team;

  Map<String, dynamic> asJsonSerializableMap(
      DynamoEncodingSupport _$dynamoEncodingSupport) {
    var _$jsonMap = super.asJsonSerializableMap(_$dynamoEncodingSupport);
    _$dynamoEncodingSupport.addValue(_$jsonMap, r'team', this.team);

    return _$jsonMap;
  }

  void fromJsonSerializableMap(Map<String, dynamic> _$jsonMap,
      DynamoDecodingSupport _$dynamoDecodingSupport) {
    super.fromJsonSerializableMap(_$jsonMap, _$dynamoDecodingSupport);
    this.team = _$dynamoDecodingSupport.decodeList(_$jsonMap[r'team'],
        factory: () => new Employee());
  }
}
