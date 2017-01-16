// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.model.circular;

import 'package:dynamo/dynamo.dart';

part 'circular_referenced_model.g.dart';

@DynamoSerializable()
class PersonRepository extends Object with _$PersonRepositoryDynamoMixin {
  List<Person> persons;
  List<Tag> tags;

  bool containsPerson(Person value) => persons.contains(value);

  Person getPersonById(int id) => persons.firstWhere((person) => person.id == id, orElse: () => throw 'Person with id ${id} not found');

  void addPerson(Person person) {
    if (persons == null) {
      persons = [];
    }
    persons.add(person);
  }
}

@DynamoSerializable()
class Person extends Object with _$PersonDynamoMixin {
  int id;
  String name;
  Person parent;
}

@DynamoSerializable()
class Tag extends Object with _$TagDynamoMixin {
  int id;
  String name;
  List<Person> persons;
}
