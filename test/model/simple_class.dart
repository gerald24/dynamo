// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.model.simple;

import 'package:dynamo/dynamo.dart';

part 'simple_class.g.dart';

@DynamoSerializable()
class SimpleClass extends Object with _$SimpleClassDynamoMixin {
  String name;
  bool matter;
  num number;
  int intNumber;
  double doubleNumber;
  DateTime createdAt;
  List list;
  Map map;
  SimpleClass child;

  @DynamoEntry(ignore: true)
  bool ignored;

  @DynamoEntry(name: "the_renamed")
  String renamed;
}
