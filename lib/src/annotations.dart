/// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
/// is governed by a BSD-style license that can be found in the LICENSE file.

part of dynamo;

class DynamoSerializable {
  const DynamoSerializable();
}

/// Customizes the name of the JSON key for a field.
///
/// If omitted, the resulting JSON key will be the
/// name of the field defined on the class.
class DynamoEntry {
  final bool ignore;
  final String name;

  const DynamoEntry({bool ignore: false, String name})
      : this.ignore = ignore,
        this.name = name;
}
