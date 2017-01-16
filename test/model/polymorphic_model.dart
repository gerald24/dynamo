// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.model.polymorphic;

import 'package:dynamo/dynamo.dart';

part 'polymorphic_model.g.dart';

@DynamoSerializable()
class Company extends Object with _$CompanyDynamoMixin {
  List<Employee> employees;
}

@DynamoSerializable()
class Employee extends Object with _$EmployeeDynamoMixin {
  String name;
}

@DynamoSerializable()
class Manager extends Employee with _$ManagerDynamoMixin {
  List<Employee> team;
}
