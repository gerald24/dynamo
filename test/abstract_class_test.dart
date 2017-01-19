/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.abstract_class;

import 'package:test/test.dart';
import 'package:dynamo/dynamo.dart';

import 'model/abstract_class.dart';

void main() {
  group('serialize without type registration', () {
    Dynamo support = new Dynamo();

    test('empty simple class', () {
      var instance = new SubClass();

      String json = support.toJson(instance);
      expect(json, '{}');

      var newInstance = new SubClass();
      var decoded = support.fromJson(json, factory: () => newInstance);
      expect(decoded, same(newInstance));
      expect(decoded.subName, isNull);
      expect(decoded.name, isNull);
      expect(decoded.matter, isNull);
      expect(decoded.number, isNull);
      expect(decoded.intNumber, isNull);
      expect(decoded.doubleNumber, isNull);
      expect(decoded.createdAt, isNull);
      expect(decoded.list, isNull);
      expect(decoded.map, isNull);
      expect(decoded.renamed, isNull);
      expect(decoded.ignored, isNull);
    });

    test('ignore property', () {
      var instance = new SubClass();
      instance.ignored = true;

      var json = '{}';
      expect(support.toJson(instance), json);

      var newInstance = new SubClass();
      newInstance.ignored = true;
      var decoded = support.fromJson(json, factory: () => newInstance);
      expect(decoded.ignored, isTrue);
    });

    test('renamed property', () {
      var instance = new SubClass();
      instance.renamed = "test";

      var json = '{"the_renamed":"test"}';
      expect(support.toJson(instance), json);

      var newInstance = new SubClass();
      newInstance.ignored = true;
      var decoded = support.fromJson(json, factory: () => newInstance);
      expect(decoded.renamed, "test");
    });

    test('all properties (simple types)', () {
      SubClass instance = new SubClass();
      instance.subName = 'not abstract';
      instance.name = 'test';
      instance.matter = true;
      instance.number = 5;
      instance.intNumber = 2;
      instance.doubleNumber = 2.11;
      instance.createdAt = new DateTime.utc(2016, 12, 24, 17, 59, 44);
      instance.list = [2, 4];
      instance.map = {"oo": "kk"};
      instance.renamed = "test";
      instance.ignored = true;

      var json = '{"name":"test","matter":true,"number":5,"intNumber":2,"doubleNumber":2.11,"createdAt":"2016-12-24T17:59:44.000Z","list":[2,4],"map":{"oo":"kk"},"the_renamed":"test","subName":"not abstract"}';
      expect(support.toJson(instance), json);

      SubClass decoded = support.fromJson(json, factory: () => new SubClass());
      expect(decoded, isNot(same(instance)));
      expect(decoded.subName, 'not abstract');
      expect(decoded.name, 'test');
      expect(decoded.matter, true);
      expect(decoded.number, 5);
      expect(decoded.intNumber, 2);
      expect(decoded.doubleNumber, 2.11);
      expect(decoded.createdAt, new DateTime.utc(2016, 12, 24, 17, 59, 44));
      expect(decoded.list.length, 2);
      expect(decoded.list[0], 2);
      expect(decoded.list[1], 4);
      expect(decoded.map.length, 1);
      expect(decoded.map["oo"], "kk");
      expect(decoded.renamed, "test");
      expect(decoded.ignored, null);
    });
    test('object reference', () {
      SubClass child = new SubClass();
      child.name = 'child';

      SubClass original = new SubClass();
      original.child = child;

      var originalJson = support.toJson(original);
      expect(originalJson, '{"child":{"name":"child"}}');

      expect(() => support.fromJson(originalJson, factory: () => new SubClass()), throws);
    });
  });

  group('serialize with type registration', () {
    Dynamo support = new Dynamo();
    support.registerType("testClass", SubClass, () => new SubClass());

    test('registerType', () {
      var json = '{"_isa_":"testClass"}';

      var decoded = support.fromJson(json);
      expect(decoded is SubClass, isTrue);
    });

    test('child reference, decode into instance', () {
      SubClass child = new SubClass();
      child.name = 'child';

      SubClass original = new SubClass();
      original.child = child;

      var originalJson = support.toJson(original);
      expect(originalJson, '{"_isa_":"testClass","child":{"_isa_":"testClass","name":"child"}}');

      SubClass test = support.fromJson(originalJson, factory: () => throw 'should use factory');
      expect(test.child.name, "child");
    });

    test('child reference, decode with instance factory', () {
      SubClass child = new SubClass();
      child.name = 'child';

      SubClass original = new SubClass();
      original.child = child;

      var originalJson = support.toJson(original);
      expect(originalJson, '{"_isa_":"testClass","child":{"_isa_":"testClass","name":"child"}}');

      SubClass test = support.fromJson(originalJson);
      expect(test.child.name, "child");
    });
  });
}
