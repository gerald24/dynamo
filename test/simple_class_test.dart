/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.simple_class;

import 'package:test/test.dart';
import 'package:dynamo/dynamo.dart';

import 'model/simple_class.dart';

void main() {
  group('serialize with type registration', () {
    Dynamo support = new Dynamo();
    support.registerType("testClass", SimpleClass, () => new SimpleClass());

    test('registerType', () {
      var json = '{"_isa_":"testClass"}';

      var decoded = support.fromJson(json);
      expect(decoded is SimpleClass, isTrue);
    });

    test('child reference, decode into instance', () {
      SimpleClass child = new SimpleClass();
      child.name = 'child';

      SimpleClass original = new SimpleClass();
      original.child = child;

      var originalJson = support.toJson(original);
      expect(originalJson, '{"_isa_":"testClass","child":{"_isa_":"testClass","name":"child"}}');

      SimpleClass test = support.fromJson(originalJson);
      expect(test.child.name, "child");
    });

    test('child reference, decode with instance factory', () {
      SimpleClass child = new SimpleClass();
      child.name = 'child';

      SimpleClass original = new SimpleClass();
      original.child = child;

      var originalJson = support.toJson(original);
      expect(originalJson, '{"_isa_":"testClass","child":{"_isa_":"testClass","name":"child"}}');

      SimpleClass test = support.fromJson(originalJson);
      expect(test.child.name, "child");
    });
  });
}
