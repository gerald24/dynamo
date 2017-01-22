/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.circular_referenced;

import 'package:dynamo/dynamo.dart';
import 'package:test/test.dart';

import 'model/circular_referenced_model.dart';

const json = '{"_isa_":"PS","persons":[{"_isa_":"Person","id":1,"name":"Yin","_id#_":1,"parent":{"_isa_":"Person","id":2,"name":"Yang","parent":{"_ref_":1},"_id#_":2}},{"_ref_":2},{"_isa_":"Person","id":3,"name":"Noname"}],"tags":[{"_isa_":"Tag","id":1,"name":"Test","persons":[{"_ref_":1},{"_ref_":2}]}]}';

void main() {
  Dynamo support = new Dynamo();
  support.registerType("PS", PersonRepository, () => new PersonRepository());
  support.registerType("Person", Person, () => new Person());
  support.registerType("Tag", Tag, () => new Tag());

  test('serialize static: circular references', () {
    var p1 = new Person()
      ..id = 1
      ..name = 'Yin';
    var p2 = new Person()
      ..id = 2
      ..name = 'Yang'
      ..parent = p1;
    p1.parent = p2;

    // p3 must not be decoded with instance id
    var p3 = new Person()
      ..id = 3
      ..name = 'Noname';

    var t1 = new Tag()
      ..id = 1
      ..name = 'Test'
      ..persons = [p1, p2];

    var store = new PersonRepository()
      ..persons = [p1, p2, p3]
      ..tags = [t1];

    expect(support.toJson(store), json);
  });

  test('parse static: circular references', () {
    var store = support.fromJson(json);

    expect(store.persons.length, 3);
    expect(store.tags.length, 1);
    var p1 = store.persons[0];
    var p2 = store.persons[1];
    var p3 = store.persons[2];
    var t1 = store.tags[0];
    expect(p1.id, 1);
    expect(p1.name, 'Yin');
    expect(p2.id, 2);
    expect(p2.name, 'Yang');
    expect(p3.id, 3);
    expect(p3.name, 'Noname');
    expect(p1.parent, same(p2));
    expect(p2.parent, same(p1));

    expect(t1.persons.length, 2);
    expect(t1.persons[0], same(p1));
    expect(t1.persons[1], same(p2));
  });

  test('parse static: decode using identifier', () {
    var store = support.fromJson(json);

    expect(store is PersonRepository, true);

    expect(store.persons.length, 3);
    expect(store.tags.length, 1);
    var p1 = store.persons[0];
    var p2 = store.persons[1];
    var p3 = store.persons[2];
    var t1 = store.tags[0];
    expect(p1.id, 1);
    expect(p1.name, 'Yin');
    expect(p2.id, 2);
    expect(p2.name, 'Yang');
    expect(p3.id, 3);
    expect(p3.name, 'Noname');
    expect(p1.parent, same(p2));
    expect(p2.parent, same(p1));

    expect(t1.persons.length, 2);
    expect(t1.persons[0], same(p1));
    expect(t1.persons[1], same(p2));
  });
}