part of dynamo_example;

@DynamoSerializable()
class AllMembersRequest extends Message with _$AllMembersRequestDynamoMixin {
}

@DynamoSerializable()
class AllMembersResponse extends Message with _$AllMembersResponseDynamoMixin {
  List<Tag> tags;
  List<Member> members;
}