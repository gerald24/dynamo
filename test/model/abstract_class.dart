// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library dynamo.test.model.abstract;

import 'package:dynamo/dynamo.dart';

part 'abstract_class.g.dart';

@DynamoSerializable()
abstract class AbstractClass extends Object with _$AbstractClassDynamoMixin {
  String name;
  bool matter;
  num number;
  int intNumber;
  double doubleNumber;
  DateTime createdAt;
  List list;
  Map map;
  AbstractClass child;

  @DynamoEntry(ignore: true)
  bool ignored;

  @DynamoEntry(name: "the_renamed")
  String renamed;
}

@DynamoSerializable()
class SubClass extends AbstractClass with _$SubClassDynamoMixin {
  String subName;

}
