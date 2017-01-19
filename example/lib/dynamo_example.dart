library dynamo_example;

import 'dart:convert';

import 'package:dynamo/dynamo.dart';

part 'dynamo_example.g.dart'; // generated

part 'model/common.dart';

part 'model/domain/member.dart';
part 'model/domain/tag.dart';

part 'model/transformer/member_type_transformer.dart';

part 'model/message/base.dart';
part 'model/message/queries.dart';

final defaultDynamo = createCommonDynamo(JSON);
final defaultTransactionDynamo = createTransactionDynamo(JSON);

Dynamo createCommonDynamo(JsonCodec json) {
  return new Dynamo(codec: json)
    ..addTransformer(new MemberTypeTransformer())
    ..registerType('member', Member, () => new Member())
    ..registerType('tag', Tag, () => new Tag())
    ;
}

Dynamo createTransactionDynamo(JsonCodec json) {
  return createCommonDynamo(JSON)
    ..registerType('allMembersRequest', AllMembersRequest, () => new AllMembersRequest())
    ..registerType('allMembersResponse', AllMembersResponse, () => new AllMembersResponse())
    ;
}
