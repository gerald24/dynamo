/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.polymorphic;

import 'package:dynamo/dynamo.dart';
import 'package:test/test.dart';

import 'model/polymorphic_model.dart';

void main() {
  group('serialize inheritance', () {
    Dynamo support = new Dynamo();
    support.registerType("employee", Employee, () => new Employee());
    support.registerType("manager", Manager, () => new Manager());
    const json = '{"employees":[{"_isa_":"employee","name":"Tim","_id#_":1},{"_isa_":"employee","name":"Tom","_id#_":2},{"_isa_":"manager","name":"Bob","team":[{"_ref_":1},{"_ref_":2}]}]}';

    test('encode', () {
      var e1 = new Employee()
        ..name = 'Tim';
      var e2 = new Employee()
        ..name = 'Tom';
      var m1 = new Manager()
        ..name = 'Bob'
        ..team = [e1, e2];

      var company = new Company()
        ..employees = [e1, e2, m1];

      expect(support.toJson(company), json);
    });

    test('decode', () {
      var company = support.fromJson(json, factory: () => new Company());

      expect(company.employees.length, 3);
      var e1 = company.employees[0];
      var e2 = company.employees[1];
      var e3 = company.employees[2];
      expect(e1 is Employee, true);
      expect(e1 is Manager, false);
      expect(e1.name, "Tim");

      expect(e2 is Employee, true);
      expect(e2 is Manager, false);
      expect(e2.name, "Tom");

      expect(e3 is Employee, true);
      expect(e3 is Manager, true);
      expect(e3.name, "Bob");

      expect(e3.team.length, 2);
      expect(e3.team[0], same(e1));
      expect(e3.team[1], same(e2));
    });
  });
}
