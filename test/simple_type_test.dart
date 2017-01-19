/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.simple_types;

import 'package:test/test.dart';
import 'package:dynamo/dynamo.dart';

void main() {
  test('serialize: bool', () {
    Dynamo support = new Dynamo();

    bool value = true;
    String json = support.toJson(value);
    expect(json, 'true');

    bool decoded = support.fromJson(json);
    expect(decoded, true);
  });

  test('serialize: int', () {
    Dynamo support = new Dynamo();

    int value = 42;
    String json = support.toJson(value);
    expect(json, '42');

    int decoded = support.fromJson(json);
    expect(decoded, 42);
  });

  test('serialize: double', () {
    Dynamo support = new Dynamo();

    double value = 3.14;
    String json = support.toJson(value);
    expect(json, '3.14');

    double decoded = support.fromJson(json);
    expect(decoded, 3.14);
  });

  test('serialize: num', () {
    Dynamo support = new Dynamo();

    num value = 123456789.2;
    String json = support.toJson(value);
    expect(json, '123456789.2');

    num decoded = support.fromJson(json);
    expect(decoded, 123456789.2);
  });


  test('serialize: String', () {
    Dynamo support = new Dynamo();

    String value = 'dart rockz';
    String json = support.toJson(value);
    expect(json, '"dart rockz"');

    String decoded = support.fromJson(json);
    expect(decoded, 'dart rockz');
  });

  test('serialize: DateTime', () {
    Dynamo support = new Dynamo();
    support.addTransformer(new DateTimeTransformer('_iso8601_'));

    DateTime value = new DateTime.utc(2016, 12, 24, 12, 59, 33);
    String json = support.toJson(value);
    expect(json, '{"_iso8601_":"2016-12-24T12:59:33.000Z"}');

    DateTime decoded = support.fromJson(json);
    expect(decoded, new DateTime.utc(2016, 12, 24, 12, 59, 33));
  });

  test('serialize: List', () {
    Dynamo support = new Dynamo();

    List value = [true, 0, 2.2, 'List', [1, 2, 3], {'o': 'k'}];
    String json = support.toJson(value);
    expect(json, '[true,0,2.2,"List",[1,2,3],{"o":"k"}]');

    List decoded = support.fromJson(json);
    expect(decoded.length, 6);
    expect(decoded[0], true);
    expect(decoded[1], 0);
    expect(decoded[2], 2.2);
    expect(decoded[3], 'List');
    expect(decoded[4], [1, 2, 3]);
    expect(decoded[5], {'o': 'k'});
  });

  test('serialize: Map', () {
    Dynamo support = new Dynamo();

    Map value = {"a": true, "b": 0, "c": 2.2, "d": 'List', "e": [1, 2, 3], "f": {'o': 'k'}};
    String json = support.toJson(value);
    expect(json, '{"a":true,"b":0,"c":2.2,"d":"List","e":[1,2,3],"f":{"o":"k"}}');

    Map decoded = support.fromJson(json);
    expect(decoded.length, 6);
    expect(decoded["a"], true);
    expect(decoded["b"], 0);
    expect(decoded["c"], 2.2);
    expect(decoded["d"], 'List');
    expect(decoded["e"], [1, 2, 3]);
    expect(decoded["f"], {'o': 'k'});
  });
}
