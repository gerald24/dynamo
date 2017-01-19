// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:build_runner/build_runner.dart';

import 'package:dynamo/dynamo_generator.dart';
import 'package:source_gen/source_gen.dart';

final PhaseGroup phases = new PhaseGroup.singleAction(
    new GeneratorBuilder(const [const DynamoMixinGenerator()]),
    new InputSet('dynamo_example', const [
      'lib/dynamo_example.dart'])
);
