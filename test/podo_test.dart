/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.podo;

import 'package:test/test.dart';
import 'package:dynamo/dynamo.dart';

import 'model/podo.dart';

void main() {
  test('simple class not implementing DynamoProtocol', () {
    Dynamo support = new Dynamo();
    var instance = new Podo();
    expect(() => support.toJson(instance), throws);
  });

  test('registered but not implementing DynamoProtocol', () {
    Dynamo support = new Dynamo();
    support.registerType("testClass", Podo, () => new Podo());
    var json = '{"_isa_":"testClass"}';
    expect(() => support.fromJson(json), throws);
  });
}
