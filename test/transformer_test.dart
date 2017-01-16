/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.transformers;

import 'package:dynamo/dynamo.dart';
import 'package:test/test.dart';

import 'model/circular_referenced_model.dart';

class PersonTransformer implements TypeTransformer<Person> {
  static const String KEY = 'personid';
  final PersonRepository store;

  PersonTransformer(this.store);

  @override
  bool canEncode(value) => value is Person && store.containsPerson(value);

  @override
  encode(Person value) => {KEY: value.id};

  @override
  bool canDecode(value) => value is Map && value.containsKey(KEY);

  @override
  Person decode(value) => store.getPersonById(value[KEY]);
}

void main() {
  test('serialize static: circular references', () {
    var max = new Person()
      ..id = 1
      ..name = "Max";
    var moritz = new Person()
      ..id = 2
      ..name = "Moritz";

    PersonRepository store = new PersonRepository();
    store.addPerson(max);
    store.addPerson(moritz);

    PersonTransformer personTransformer = new PersonTransformer(store);

    Dynamo support = new Dynamo();
    support.registerType("Person", Person, () => new Person());
    support.addTransformer(personTransformer);

    String json = support.toJson([max, moritz]);
    expect(json, '[{"personid":1},{"personid":2}]');

    List<Person> decoded = support.fromJson(json);
    expect(decoded, isList);
    expect(decoded.length, 2);
    expect(decoded[0], same(max));
    expect(decoded[1], same(moritz));
  });

}